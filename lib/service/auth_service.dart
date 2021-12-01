import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  String baseUrl = 'http://192.168.190.3:3000';

  Future<dynamic> register({
    String? name,
    String? nip,
    String? divisi,
    String? username,
    int? divisiid,
    String? password,
  }) async {
    var url = Uri.parse('$baseUrl/register');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'nip': nip,
      'divisi': divisi,
      'username': username,
      'divisiid': divisiid,
      'password': password,
    });

    return await http.post(
      url,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> login({
    String? username,
    String? password,
  }) async {
    var url = Uri.parse('$baseUrl/login');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'username': username,
      'password': password,
    });

    return await http.post(
      url,
      headers: headers,
      body: body,
    );
  }
}
