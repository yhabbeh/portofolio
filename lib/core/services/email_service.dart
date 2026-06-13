import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/email_config.dart';

class EmailService {
  final http.Client _client;

  EmailService({http.Client? client}) : _client = client ?? http.Client();

  Future<void> send({
    required String name,
    required String email,
    required String message,
  }) async {
    final response = await _client.post(
      Uri.parse(EmailConfig.formEndpoint),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message. Please try again later.');
    }
  }

  void dispose() {
    _client.close();
  }
}
