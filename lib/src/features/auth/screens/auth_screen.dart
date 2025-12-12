import 'package:flutter/material.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseService = FirebaseService();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final router = GoRouter.of(context);
                final email = _emailController.text;
                final password = _passwordController.text;

                if (_isLogin) {
                  final user = await _firebaseService.signInWithEmailPassword(
                    email,
                    password,
                  );
                  if (user != null) {
                    router.go('/home');
                  }
                } else {
                  final user = await _firebaseService.signUpWithEmailPassword(
                    email,
                    password,
                  );
                  if (user != null) {
                    await _firebaseService.createUserProfile(user.uid, email);
                    router.go('/food-preferences');
                  }
                }
              },
              child: Text(_isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
