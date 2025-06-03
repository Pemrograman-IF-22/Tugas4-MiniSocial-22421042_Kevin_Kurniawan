
import 'package:flutter/material.dart';
import 'package:mini_social/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Mausk ke Aplikasi',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0,),
                TextField(
                  controller: password,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      debugPrint('Email: ${email.text} Password: ${password.text}');

                      final authController = AuthController();
                      final success = await authController.login(
                        email: email.text,
                        password: password.text,
                      );

                      if (success){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login berhasil'))
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                    ),
                    child: const Text('login', style: TextStyle(
                      color: Colors.white
                    ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}