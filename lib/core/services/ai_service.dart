import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tripplus/core/services/trip_context_packer.dart';

// ── Domain types ───────────────────────────────────────────────────────────

enum AiRole { user, assistant }

class AiMessage {
  const AiMessage({required this.role, required this.content});

  final AiRole role;
  final String content;

  Map<String, dynamic> toJson() => {
        'role': role == AiRole.user ? 'user' : 'assistant',
        'content': content,
      };

  factory AiMessage.fromJson(Map<String, dynamic> json) => AiMessage(
        role: json['role'] == 'user' ? AiRole.user : AiRole.assistant,
        content: json['content'] as String,
      );
}

class AiToolCall {
  const AiToolCall({required this.name, required this.input});

  final String name;
  final Map<String, dynamic> input;
}

class AiChatRequest {
  const AiChatRequest({
    required this.messages,
    this.systemPrompt,
    this.tripContext,
    this.tools = const [],
    this.maxTokens = 1024,
  });

  final List<AiMessage> messages;
  final String? systemPrompt;
  final TripContextPacket? tripContext;
  final List<Map<String, dynamic>> tools;
  final int maxTokens;
}

class AiChatResponse {
  const AiChatResponse({
    required this.text,
    this.toolCalls = const [],
    required this.stopReason,
  });

  final String text;
  final List<AiToolCall> toolCalls;

  /// `'end_turn'` | `'tool_use'` | `'max_tokens'`
  final String stopReason;
}

// ── Interface ──────────────────────────────────────────────────────────────

abstract interface class AiService {
  /// Yields text deltas as they arrive from the server (SSE).
  Stream<String> streamChat(AiChatRequest request);

  /// One-shot completion — awaits the complete response.
  Future<AiChatResponse> chat(AiChatRequest request);
}

// ── Remote implementation — calls the P3-002 Cloud Function proxy ──────────

class RemoteAiService implements AiService {
  RemoteAiService({
    required Dio dio,

    /// Returns a Firebase ID token for the current user; null when signed out.
    required Future<String?> Function() getIdToken,
    required String proxyBaseUrl,
  })  : _dio = dio,
        _getIdToken = getIdToken,
        _proxyBaseUrl = proxyBaseUrl;

  final Dio _dio;
  final Future<String?> Function() _getIdToken;
  final String _proxyBaseUrl;
  final _log = Logger();

  @override
  Future<AiChatResponse> chat(AiChatRequest request) async {
    _log.d('AiService.chat: ${_preview(request)}');
    final headers = await _authHeaders();
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_proxyBaseUrl/aiProxy',
        data: _buildPayload(request),
        options: Options(headers: headers),
      );
      return _parseResponse(response.data!);
    } on DioException catch (e) {
      _log.e('AiService.chat error', error: e);
      throw AiServiceException('network: ${e.message}');
    }
  }

  @override
  Stream<String> streamChat(AiChatRequest request) async* {
    _log.d('AiService.streamChat: ${_preview(request)}');
    final headers = await _authHeaders();
    try {
      final response = await _dio.post<ResponseBody>(
        '$_proxyBaseUrl/aiStream',
        data: _buildPayload(request),
        options: Options(
          headers: headers,
          responseType: ResponseType.stream,
        ),
      );

      await for (final chunk in response.data!.stream) {
        final raw = utf8.decode(chunk);
        for (final line in raw.split('\n')) {
          if (!line.startsWith('data: ')) continue;
          final payload = line.substring(6).trim();
          if (payload == '[DONE]') return;
          try {
            final json = jsonDecode(payload) as Map<String, dynamic>;
            final delta = json['delta'] as String?;
            if (delta != null && delta.isNotEmpty) yield delta;
          } catch (_) {}
        }
      }
    } on DioException catch (e) {
      _log.e('AiService.streamChat error', error: e);
      throw AiServiceException('stream: ${e.message}');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final token = await _getIdToken();
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }

  Map<String, dynamic> _buildPayload(AiChatRequest req) => {
        'messages': req.messages.map((m) => m.toJson()).toList(),
        if (req.systemPrompt != null) 'system': req.systemPrompt,
        if (req.tripContext != null) 'tripContext': req.tripContext!.toJson(),
        if (req.tools.isNotEmpty) 'tools': req.tools,
        'maxTokens': req.maxTokens,
      };

  AiChatResponse _parseResponse(Map<String, dynamic> data) {
    final text = (data['text'] as String?) ?? '';
    final stopReason = (data['stopReason'] as String?) ?? 'end_turn';
    final rawTools = (data['toolCalls'] as List<dynamic>?) ?? [];
    final toolCalls = rawTools.map((t) {
      final m = t as Map<String, dynamic>;
      return AiToolCall(
        name: m['name'] as String,
        input: (m['input'] as Map<String, dynamic>?) ?? {},
      );
    }).toList();
    return AiChatResponse(text: text, toolCalls: toolCalls, stopReason: stopReason);
  }

  String _preview(AiChatRequest req) {
    final last = req.messages.lastOrNull?.content ?? '';
    return last.length > 60 ? '${last.substring(0, 60)}…' : last;
  }
}

// ── Exception ──────────────────────────────────────────────────────────────

class AiServiceException implements Exception {
  const AiServiceException(this.message);

  final String message;

  @override
  String toString() => 'AiServiceException: $message';
}
