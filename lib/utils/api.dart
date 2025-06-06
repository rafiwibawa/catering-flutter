import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static String get authUrl =>
      dotenv.env['API_URL'] ?? 'https://default-api.com';
  static const String authKey = 'Your Token';
}
