import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/app_env.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const Duration _requestTimeout = Duration(seconds: 8);

  final http.Client _client;
  String? _authToken;
  String? _resolvedBaseUrl;

  String get currentBaseUrl => _resolvedBaseUrl ?? AppEnv.apiBaseUrl;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    final http.Response response = await _sendWithBackendFallback(
      path,
      (Uri uri) => _client.get(
        uri,
        headers: _headers(),
      ),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final http.Response response = await _sendWithBackendFallback(
      path,
      (Uri uri) => _client.post(
        uri,
        headers: _headers(contentType: 'application/json'),
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final http.Response response = await _sendWithBackendFallback(
      path,
      (Uri uri) => _client.patch(
        uri,
        headers: _headers(contentType: 'application/json'),
        body: jsonEncode(body ?? <String, dynamic>{}),
      ),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> deleteJson(String path) async {
    final http.Response response = await _sendWithBackendFallback(
      path,
      (Uri uri) => _client.delete(
        uri,
        headers: _headers(),
      ),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String>? fields,
    ApiMultipartFile? file,
  }) async {
    final http.Response response = await _sendWithBackendFallback(path, (Uri uri) async {
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      request.headers.addAll(_headers());

      if (file != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            file.fieldName,
            file.bytes,
            filename: file.filename,
          ),
        );
      }

      final http.StreamedResponse streamedResponse =
          await request.send().timeout(_requestTimeout);
      return http.Response.fromStream(streamedResponse);
    });
    return _decodeResponse(response);
  }

  Future<http.Response> _sendWithBackendFallback(
    String path,
    Future<http.Response> Function(Uri uri) send,
  ) async {
    final List<String> candidates = _candidateBaseUrls();
    Object? lastError;

    for (final String baseUrl in candidates) {
      try {
        final http.Response response =
            await send(AppEnv.uriFor(baseUrl, path)).timeout(_requestTimeout);
        _resolvedBaseUrl = baseUrl;
        return response;
      } catch (error) {
        lastError = error;
      }
    }

    throw BackendConnectionException(
      attemptedBaseUrls: candidates,
      cause: lastError,
    );
  }

  List<String> _candidateBaseUrls() {
    final List<String> configured = AppEnv.apiBaseUrlCandidates;
    if (_resolvedBaseUrl == null) {
      return configured;
    }

    return <String>[
      _resolvedBaseUrl!,
      ...configured.where((String url) => url != _resolvedBaseUrl),
    ];
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final dynamic decoded = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: decoded is Map<String, dynamic>
            ? (decoded['message']?.toString() ?? 'Request failed')
            : 'Request failed',
      );
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{'data': decoded};
  }

  Map<String, String> _headers({String? contentType}) {
    final Map<String, String> headers = <String, String>{};
    if (contentType != null) {
      headers['Content-Type'] = contentType;
    }
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }
}

class BackendConnectionException implements Exception {
  BackendConnectionException({
    required this.attemptedBaseUrls,
    required this.cause,
  });

  final List<String> attemptedBaseUrls;
  final Object? cause;

  String get message {
    final String urls = attemptedBaseUrls.join(', ');
    return 'Unable to reach the backend. Tried: $urls';
  }

  @override
  String toString() => 'BackendConnectionException($attemptedBaseUrls): $cause';
}

class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    required this.message,
  });

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiMultipartFile {
  const ApiMultipartFile({
    required this.fieldName,
    required this.filename,
    required this.bytes,
  });

  final String fieldName;
  final String filename;
  final Uint8List bytes;
}
