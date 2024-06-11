// global_variables.dart
import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariables {
  static String? authToken;
}

Future<void> initializeSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  GlobalVariables.authToken = prefs.getString('token');
}
