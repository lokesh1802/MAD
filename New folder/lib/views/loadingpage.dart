import 'package:flutter/material.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/sidepage.dart';
import 'package:battleships/views/loginpage.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Use SessionManager to check if a user is already logged in
  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading delay
    if (mounted) {
      setState(() {
        isLoggedIn = loggedIn;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF2F3F8),
      ),
      home: isLoading
          ? const SplashScreen() // Display splash screen while loading
          : (isLoggedIn ? const FirstPage() : const LoginScreen()),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or Branding Image
            const Icon(
              Icons.videogame_asset,
              color: Colors.indigo,
              size: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              "Battleships",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 24),
            // Animated Loader
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              "Loading...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
