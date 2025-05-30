import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';

class NetworkService {
  final http.Client client;
  final String baseUrl;

  NetworkService({required this.client, required this.baseUrl});

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    headers = await _attachAuthHeader(headers);
    final response = await client.get(uri, headers: headers);
    return _handleResponse(response, () async {
      headers = await _attachAuthHeader(headers);
      return client.get(uri, headers: headers);
    });
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    headers = await _attachAuthHeader(headers);
    final response = await client.post(
      uri,
      headers: headers ?? {'Content-Type': 'application/json'},
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response, () async {
      headers = await _attachAuthHeader(headers);
      return client.post(uri, headers: headers, body: jsonEncode(body ?? {}));
    });
  }

  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    headers = await _attachAuthHeader(headers);
    final response = await client.put(
      uri,
      headers: headers ?? {'Content-Type': 'application/json'},
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response, () async {
      headers = await _attachAuthHeader(headers);
      return client.put(uri, headers: headers, body: jsonEncode(body ?? {}));
    });
  }

  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    headers = await _attachAuthHeader(headers);
    final response = await client.delete(uri, headers: headers);
    return _handleResponse(response, () async {
      headers = await _attachAuthHeader(headers);
      return client.delete(uri, headers: headers);
    });
  }

  Future<Map<String, dynamic>> postMultipartWithJsonField({
    required String endpoint,
    required Map<String, String> jsonMap,
    required File file,
  }) async {
    Future<http.Response> sendRequest(String token) async {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['app'] = 'SA';

      final imagePart = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imagePart);

      // Add data (as JSON string with correct media type)
      final jsonPart = http.MultipartFile.fromString(
        'data',
        jsonEncode(jsonMap),
        contentType: MediaType('application', 'json'),
      );
      request.files.add(jsonPart);

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    }

    try {
      String? token = SharedPreferencesHelper.getString("access_token");
      if (token == null) throw Exception("No access token");

      http.Response response = await sendRequest(token);

      // Retry on 401
      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) throw Exception("Unauthorized and refresh failed");
        token = SharedPreferencesHelper.getString("access_token");
        if (token == null) throw Exception("Refreshed token missing");
        response = await sendRequest(token);
      }

      print('Multipart Status Code: ${response.statusCode}');
      print('Multipart response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Request failed [${response.statusCode}]: ${response.body}");
      }
    } catch (e) {
      print('Exception during multipart KYC upload: $e');
      throw Exception("KYC Upload failed: $e");
    }
  }

  Future<Map<String, dynamic>> putMultipartWithJsonField({
    required String endpoint,
    required Map<String, String> jsonMap,
    required File file,
  }) async {
    Future<http.Response> sendRequest(String token) async {
      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('PUT', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['app'] = 'SA';

      final imagePart = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(imagePart);

      // Add data (as JSON string with correct media type)
      final jsonPart = http.MultipartFile.fromString(
        'data',
        jsonEncode(jsonMap),
        contentType: MediaType('application', 'json'),
      );
      request.files.add(jsonPart);

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    }

    try {
      String? token = SharedPreferencesHelper.getString("access_token");
      if (token == null) throw Exception("No access token");

      http.Response response = await sendRequest(token);

      // Retry on 401
      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) throw Exception("Unauthorized and refresh failed");
        token = SharedPreferencesHelper.getString("access_token");
        if (token == null) throw Exception("Refreshed token missing");
        response = await sendRequest(token);
      }

      print('Multipart Status Code: ${response.statusCode}');
      print('Multipart response: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Request failed [${response.statusCode}]: ${response.body}");
      }
    } catch (e) {
      print('Exception during multipart KYC upload: $e');
      throw Exception("KYC Upload failed: $e");
    }
  }

  Future<Map<String, dynamic>> _handleResponse(
    http.Response response,
    Future<http.Response> Function() retryCall,
  ) async {
    final statusCode = response.statusCode;
    final method = response.request?.method ?? 'UNKNOWN';
    final url = response.request?.url.toString() ?? 'UNKNOWN';
    final headers = response.request?.headers ?? {};

    print('🔸 METHOD: $method');
    print('🔸 URL: $url');
    print('🔸 HEADERS: $headers');
    print('🔸 STATUS: $statusCode');
    print('🔸 BODY: ${response.body}');

    if (statusCode == 401) {
      final success = await _refreshToken();
      if (success) {
        final retryResponse = await retryCall();
        if (retryResponse.statusCode >= 200 && retryResponse.statusCode < 300) {
          return jsonDecode(retryResponse.body);
        } else {
          throw Exception(
              'Retry failed [${retryResponse.statusCode}]: ${retryResponse.body}');
        }
      } else {
        throw Exception('401 Unauthorized and token refresh failed');
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        throw Exception('Invalid JSON response: ${response.body}');
      }
    } else {
      throw Exception('Request failed [$statusCode]: ${response.body}');
    }
  }

  Future<Map<String, String>> _attachAuthHeader(
      Map<String, String>? headers) async {
    final accessToken = SharedPreferencesHelper.getString("access_token");
    final updatedHeaders = Map<String, String>.from(headers ?? {});
    if (accessToken != null && accessToken.isNotEmpty) {
      updatedHeaders['Authorization'] = 'Bearer $accessToken';
    }
    return updatedHeaders;
  }

  Future<bool> _refreshToken() async {
    final refreshToken = SharedPreferencesHelper.getString("refresh_token");
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final uri = Uri.parse(
      "https://202.88.237.252:8804/gateway-service/token-service/authentication/tokenRequestByRefreshToken",
    );

    try {
      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'app': 'SA',
        },
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        SharedPreferencesHelper.saveString(
            "access_token", data["access_token"]);
        SharedPreferencesHelper.saveString(
            "refresh_token", data["refresh_token"]);
        SharedPreferencesHelper.saveString("id_token", data["id_token"]);
        return true;
      } else {
        print(
            '🔁 Refresh token failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('🔁 Exception while refreshing token: $e');
      return false;
    }
  }
}

http.Client createUnsafeClient() {
  final ioClient = HttpClient()
    ..badCertificateCallback = (cert, host, port) => true;
  return IOClient(ioClient);
}
