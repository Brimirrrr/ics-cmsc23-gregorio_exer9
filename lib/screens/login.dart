import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'todo_page.dart';
import 'signup.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await context.read<MyAuthProvider>().signIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                  // Navigate to TodoPage after successful login
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => TodoPage()),
                  );
                } catch (e) {
                  // Handle login error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to login: $e')),
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Navigate to SignUpPage
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                "Not signed up? Click here to sign up",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
