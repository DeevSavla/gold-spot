import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/app_env.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Uri _uri(String path) {
    final String normalizedBase = AppEnv.apiBaseUrl.replaceAll(RegExp(r'/$'), '');
    final String normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$normalizedBase$normalizedPath');
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    final http.Response response = await _client.get(
      _uri(path),
      headers: _headers(),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final http.Response response = await _client.post(
      _uri(path),
      headers: _headers(contentType: 'application/json'),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final http.Response response = await _client.patch(
      _uri(path),
      headers: _headers(contentType: 'application/json'),
      body: jsonEncode(body ?? <String, dynamic>{}),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> deleteJson(String path) async {
    final http.Response response = await _client.delete(
      _uri(path),
      headers: _headers(),
    );
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String>? fields,
    ApiMultipartFile? file,
  }) async {
    final http.MultipartRequest request = http.MultipartRequest('POST', _uri(path));

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

    final http.StreamedResponse streamedResponse = await request.send();
    final http.Response response = await http.Response.fromStream(streamedResponse);
    return _decodeResponse(response);
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
