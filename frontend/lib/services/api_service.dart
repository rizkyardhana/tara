import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? _defaultBaseUrl;

  static const _defaultBaseUrl = String.fromEnvironment(
    'TARA_API_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );

  final String baseUrl;
  String? token;
  static String? sessionToken;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if ((token ?? sessionToken) != null) 'Authorization': 'Bearer ${token ?? sessionToken}',
  };

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> _get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    final data = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        data is Map ? data['message'] ?? 'Request gagal' : 'Request gagal',
      );
    }
    return data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _post('/auth/login', {
      'email': email,
      'password': password,
    });
    token = result['token'] as String?;
    sessionToken = token;
    return result;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    final result = await _post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });
    token = result['token'] as String?;
    sessionToken = token;
    return result;
  }

  Future<Map<String, dynamic>> loginWithGoogle({
    required String name,
    required String email,
    required String providerId,
  }) async {
    final result = await _post('/auth/google', {
      'name': name,
      'email': email,
      'providerId': providerId,
    });
    token = result['token'] as String?;
    sessionToken = token;
    return result;
  }

  Future<Map<String, dynamic>> getAdminOverview() async => await _get('/admin/overview');

  Future<List<dynamic>> getAdminUsers() async => await _get('/admin/users');

  Future<Map<String, dynamic>> updateAdminUser(String id, {required String role, required String status}) async {
    final response = await http.patch(Uri.parse('$baseUrl/admin/users/$id'), headers: _headers, body: jsonEncode({'role': role, 'status': status}));
    return _decode(response);
  }

  Future<void> deleteAdminUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/admin/users/$id'), headers: _headers);
    _decode(response);
  }

  Future<Map<String, dynamic>> getProfile() async => await _get('/profile');

  Future<Map<String, dynamic>> updateProfile({
    required String currentEmail,
    required String name,
    required String email,
    required String phone,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: _headers,
      body: jsonEncode({
        'currentEmail': currentEmail,
        'name': name,
        'email': email,
        'phone': phone,
      }),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> saveMood(Map<String, dynamic> mood) async {
    return await _post('/moods', mood);
  }

  Future<List<dynamic>> getMoods() async => await _get('/moods');

  Future<Map<String, dynamic>> getJournalStatistics() async =>
      await _get('/journal-statistics');

  Future<Map<String, dynamic>> saveJournal(Map<String, dynamic> journal) async {
    return await _post('/journals', journal);
  }

  Future<List<dynamic>> getJournals() async => await _get('/journals');

  Future<Map<String, dynamic>> sendChat(
    String content, {
    String? userId,
  }) async {
    return await _post('/chat', {'content': content, 'userId': userId});
  }

  Future<List<dynamic>> getChatHistory() async => await _get('/chat');

  Future<List<dynamic>> getBisindoVideos() async => await _get('/bisindo');

  Future<Map<String, dynamic>> getTamanPikiran() async =>
      await _get('/taman-pikiran');
}
