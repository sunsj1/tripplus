import * as admin from 'firebase-admin';

const WINDOW_MS = 60_000; // 1-minute sliding window
const MAX_REQUESTS = 20;   // per uid per window

/**
 * Firestore-backed token-bucket rate limiter.
 * Throws `'RATE_LIMIT_EXCEEDED'` when the uid exceeds MAX_REQUESTS per window.
 * Uses a Firestore transaction so concurrent requests are safe.
 */
export async function checkRateLimit(uid: string): Promise<void> {
  const db = admin.firestore();
  const ref = db.collection('_aiRateLimits').doc(uid);

  await db.runTransaction(async (tx) => {
    const doc = await tx.get(ref);
    const now = Date.now();

    if (!doc.exists) {
      tx.set(ref, { count: 1, windowStart: now });
      return;
    }

    const { count, windowStart } = doc.data() as {
      count: number;
      windowStart: number;
    };

    if (now - windowStart > WINDOW_MS) {
      // Expired window — reset
      tx.update(ref, { count: 1, windowStart: now });
      return;
    }

    if (count >= MAX_REQUESTS) {
      throw new Error('RATE_LIMIT_EXCEEDED');
    }

    tx.update(ref, { count: count + 1 });
  });
}
