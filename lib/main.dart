import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shulea_app/colors/colors.dart';
import 'package:shulea_app/screens/home_screen.dart';
import 'package:shulea_app/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'shulea app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(0, 255, 255, 10),
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.quicksand(
            fontSize: 35,
          ),
          bodyMedium: GoogleFonts.quicksand(fontSize: 20),
          displaySmall: GoogleFonts.quicksand(fontSize: 15),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthCheck();
  }

  Future<void> _navigateToAuthCheck() async {
    await Future.delayed(const Duration(seconds: 10));
    // Display splash screen for 3 seconds
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AuthCheck(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: DecoratedBox(
      decoration: BoxDecoration(color: aquaColor),
      child: Center(
        child: Text(
          "shulea app",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
    ));
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  AuthCheckState createState() => AuthCheckState();
}

class AuthCheckState extends State<AuthCheck> {
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(
        const Duration(seconds: 10)); // Simulate loading for 10 seconds
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final DateTime now = DateTime.now();
      bool isTokenExpired = JwtDecoder.isExpired(token);

      if (!isTokenExpired) {
        DateTime expiryDate = JwtDecoder.getExpirationDate(token);

        if (expiryDate.isAfter(now)) {
          setState(() {
            _isAuthenticated = true;
          });
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: greyColor,
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: aquaColor,
              strokeWidth: 4,
            ),
          ),
        ),
      );
    }
    return _isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}
