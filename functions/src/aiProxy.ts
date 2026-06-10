import Anthropic from '@anthropic-ai/sdk';
import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { logger } from 'firebase-functions/v2';
import { checkRateLimit } from './rateLimiter';
import { buildSystemPrompt, SYSTEM_PROMPT_V1, TripContext } from './promptTemplates';

if (!admin.apps.length) {
  admin.initializeApp();
}

// API key is set via `firebase functions:secrets:set ANTHROPIC_API_KEY`
// and accessed at runtime via process.env. Never committed or bundled.
const getAnthropic = () =>
  new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY ?? '' });

const MODEL = 'claude-haiku-4-5-20251001';

interface AiMessage {
  role: 'user' | 'assistant';
  content: string;
}

interface ProxyRequestBody {
  messages: AiMessage[];
  system?: string;
  tripContext?: TripContext;
  tools?: Anthropic.Tool[];
  maxTokens?: number;
}

// ── Auth helper ────────────────────────────────────────────────────────────

async function verifyBearer(authHeader: string | undefined): Promise<string> {
  if (!authHeader?.startsWith('Bearer ')) {
    throw Object.assign(new Error('Missing auth token'), { status: 401 });
  }
  const token = authHeader.slice(7);
  const decoded = await admin.auth().verifyIdToken(token);
  return decoded.uid;
}

// ── One-shot (non-streaming) ───────────────────────────────────────────────

export const aiProxy = onRequest(
  { timeoutSeconds: 60, memory: '256MiB', region: 'us-central1' },
  async (req, res) => {
    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method Not Allowed' });
      return;
    }

    let uid: string;
    try {
      uid = await verifyBearer(req.headers.authorization);
    } catch {
      res.status(401).json({ error: 'Unauthorized' });
      return;
    }

    try {
      await checkRateLimit(uid);
    } catch {
      res.status(429).json({ error: 'Rate limit exceeded — try again in a minute' });
      return;
    }

    const body = req.body as ProxyRequestBody;
    const systemPrompt = buildSystemPrompt(
      body.system ?? SYSTEM_PROMPT_V1,
      body.tripContext,
    );

    try {
      const response = await getAnthropic().messages.create({
        model: MODEL,
        max_tokens: body.maxTokens ?? 1024,
        system: systemPrompt,
        messages: body.messages,
        tools: body.tools ?? [],
      });

      const textBlock = response.content.find((b) => b.type === 'text');
      const toolBlocks = response.content.filter((b) => b.type === 'tool_use');

      res.status(200).json({
        text: textBlock?.type === 'text' ? textBlock.text : '',
        toolCalls: toolBlocks
          .filter((b) => b.type === 'tool_use')
          .map((b) => (b.type === 'tool_use' ? { name: b.name, input: b.input } : null))
          .filter(Boolean),
        stopReason: response.stop_reason ?? 'end_turn',
      });
    } catch (err) {
      logger.error('aiProxy upstream error', err);
      res.status(502).json({ error: 'AI service error' });
    }
  },
);

// ── Streaming SSE ─────────────────────────────────────────────────────────

export const aiStream = onRequest(
  { timeoutSeconds: 120, memory: '256MiB', region: 'us-central1' },
  async (req, res) => {
    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method Not Allowed' });
      return;
    }

    let uid: string;
    try {
      uid = await verifyBearer(req.headers.authorization);
    } catch {
      res.status(401).json({ error: 'Unauthorized' });
      return;
    }

    try {
      await checkRateLimit(uid);
    } catch {
      res.status(429).json({ error: 'Rate limit exceeded' });
      return;
    }

    const body = req.body as ProxyRequestBody;
    const systemPrompt = buildSystemPrompt(
      body.system ?? SYSTEM_PROMPT_V1,
      body.tripContext,
    );

    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.flushHeaders();

    try {
      const stream = getAnthropic().messages.stream({
        model: MODEL,
        max_tokens: body.maxTokens ?? 1024,
        system: systemPrompt,
        messages: body.messages,
      });

      for await (const event of stream) {
        if (
          event.type === 'content_block_delta' &&
          event.delta.type === 'text_delta'
        ) {
          res.write(`data: ${JSON.stringify({ delta: event.delta.text })}\n\n`);
        }
      }

      res.write('data: [DONE]\n\n');
    } catch (err) {
      logger.error('aiStream error', err);
      res.write(`data: ${JSON.stringify({ error: String(err) })}\n\n`);
    } finally {
      res.end();
    }
  },
);
