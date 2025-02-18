import 'dart:convert';
import 'package:battleships/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/sidepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please log in to continue.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            (isLoading)
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _login(context),
                        icon: const Icon(Icons.login),
                        label: const Text('Log In'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _register(context),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Register'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    try {
      final username = usernameController.text;
      final password = passwordController.text;

      String data = jsonEncode(
          <String, String>{"username": username, "password": password});

      setState(() {
        isLoading = true;
      });

      final response = await ApiHelper.callApi('/login', data);
      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Parse and save the session token
        final sessionToken = jsonRes['access_token'];
        await SessionManager.setSessionToken(sessionToken, username);

        if (!mounted) return;

        // Navigate to the main screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const FirstPage(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      print('An error occurred during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _register(BuildContext context) async {
    try {
      final username = usernameController.text;
      final password = passwordController.text;

      String data = jsonEncode(
          <String, String>{"username": username, "password": password});

      setState(() {
        isLoading = true;
      });

      final response = await ApiHelper.callApi('/register', data);
      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Parse and save the session token
        final sessionToken = jsonRes['access_token'];
        await SessionManager.setSessionToken(sessionToken, username);

        if (!mounted) return;

        // Navigate to the main screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const FirstPage(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    } catch (e) {
      print('An error occurred during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
