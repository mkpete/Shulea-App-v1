import 'package:shared_preferences/shared_preferences.dart';

class ApiEndpoints {
  // Base URL for the API
  static const String baseUrl = 'https://kovoschool-backend.vercel.app/api';

  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}

Map<String, String> headers = {};

Future<void> initHeaders() async {
  String? token = await getAccessTokenFromLocalStorage();
  headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}

Future<String?> getAccessTokenFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Retrieve access token from shared preferences
  return prefs.getString('token');
}
