import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl = 'https://api-social.ahmadlabs.my.id';

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.data['token'] != null) {
        await _storage.write(key: 'token', value: response.data['token']);
      }
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Post endpoints
  Future<List<dynamic>> getPosts() async {
    try {
      final response = await _dio.get('$baseUrl/posts');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPost(String content, String? imageUrl) async {
    try {
      final response = await _dio.post(
        '$baseUrl/posts',
        data: {
          'content': content,
          if (imageUrl != null) 'image_url': imageUrl,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _dio.post('$baseUrl/posts/$postId/like');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await _dio.delete('$baseUrl/posts/$postId/like');
    } catch (e) {
      rethrow;
    }
  }

  // User endpoints
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('$baseUrl/users/profile');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(String name, String? bio) async {
    try {
      final response = await _dio.put(
        '$baseUrl/users/profile',
        data: {
          'name': name,
          if (bio != null) 'bio': bio,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}

class FlutterSecureStorage {
  const FlutterSecureStorage();
  
  delete({required String key}) {}
  
  read({required String key}) {}
  
  write({required String key, required value}) {}
} 