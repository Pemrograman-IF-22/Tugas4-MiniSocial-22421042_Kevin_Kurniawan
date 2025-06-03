import 'package:flutter/material.dart';
import 'package:mini_social/views/screens/home_screen.dart';
import 'package:mini_social/views/screens/login_screen.dart';
import 'package:mini_social/views/screens/register_screen.dart';
import 'package:mini_social/views/screens/profile_screen.dart';
import 'package:mini_social/views/screens/create_post_screen.dart';
import 'package:mini_social/core/network/dio_client.dart';
import 'package:mini_social/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    final authController = AuthController();
    final isLoggedIn = await authController.isLoggedIn();
    return isLoggedIn ? '/home' : '/login';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Mini Social',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
          initialRoute: snapshot.data,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/create-post': (context) => const CreatePostScreen(),
          },
        );
      },
    );
  }
}