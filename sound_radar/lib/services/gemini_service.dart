import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../config/secrets.dart' as secrets;
import '../models/song.dart';

class GeminiService {
  static const String _defaultModel = 'gemini-1.5-flash';

  const GeminiService();

  Future<String> generateUserDescriptionFromSongs(
    List<Song> songs, {
    String language = 'es',
    String model = _defaultModel,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (songs.isEmpty) {
      return language == 'es'
          ? 'Explorando música nueva últimamente.'
          : 'Exploring new music lately.';
    }

    if (kIsWeb) {
      throw UnsupportedError('GeminiService with HttpClient is not supported on Web.');
    }

    final apiKey = _resolveApiKey();
    if (apiKey.isEmpty) {
      throw StateError(
        'Missing Gemini API key. Set it in lib/config/secrets.dart or run with --dart-define=GEMINI_API_KEY=YOUR_KEY',
      );
    }

    final songsText = songs
        .take(20)
        .map((s) => '- ${s.title} — ${s.artist}')
        .join('\n');

    final prompt = language == 'es'
        ? '''
Escribe una descripción corta (máximo 2 frases) del gusto musical de esta persona basándote SOLO en estas últimas canciones.
Tono: moderno, amigable, sin exagerar ni mencionar que eres una IA. No uses emojis.
Canciones:
$songsText
'''
        : '''
Write a short description (max 2 sentences) of this person's music taste based ONLY on these last songs.
Tone: modern, friendly, not over the top, and don't mention being an AI. No emojis.
Songs:
$songsText
''';

    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/$model:generateContent',
      {'key': apiKey},
    );

    final payload = <String, Object?>{
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 80,
      },
    };

    final client = HttpClient();
    client.connectionTimeout = timeout;
    try {
      final request = await client.postUrl(uri).timeout(timeout);
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode(payload)));

      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Gemini error ${response.statusCode}: $responseBody',
          uri: uri,
        );
      }

      final decoded = jsonDecode(responseBody);
      final text = _extractText(decoded);
      if (text == null || text.trim().isEmpty) {
        throw const FormatException('Gemini response missing text.');
      }
      return text.trim();
    } finally {
      client.close(force: true);
    }
  }

  String? _extractText(Object? decoded) {
    if (decoded is! Map) return null;
    final candidates = decoded['candidates'];
    if (candidates is! List || candidates.isEmpty) return null;
    final first = candidates.first;
    if (first is! Map) return null;
    final content = first['content'];
    if (content is! Map) return null;
    final parts = content['parts'];
    if (parts is! List || parts.isEmpty) return null;
    final part0 = parts.first;
    if (part0 is! Map) return null;
    final text = part0['text'];
    return text is String ? text : null;
  }

  String _resolveApiKey() {
    if (secrets.geminiApiKey.trim().isNotEmpty) return secrets.geminiApiKey.trim();
    const fromDefine = String.fromEnvironment('GEMINI_API_KEY');
    return fromDefine.trim();
  }
}
