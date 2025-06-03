import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPosts();
      _posts = response.map((json) => Post.fromJson(json)).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(String content, String? imageUrl) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createPost(content, imageUrl);
      final newPost = Post.fromJson(response);
      _posts.insert(0, newPost);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex == -1) return;

    final post = _posts[postIndex];
    try {
      if (post.isLiked) {
        await _apiService.unlikePost(postId);
        _posts[postIndex] = Post(
          id: post.id,
          content: post.content,
          imageUrl: post.imageUrl,
          user: post.user,
          likesCount: post.likesCount - 1,
          isLiked: false,
          createdAt: post.createdAt,
          updatedAt: post.updatedAt,
        );
      } else {
        await _apiService.likePost(postId);
        _posts[postIndex] = Post(
          id: post.id,
          content: post.content,
          imageUrl: post.imageUrl,
          user: post.user,
          likesCount: post.likesCount + 1,
          isLiked: true,
          createdAt: post.createdAt,
          updatedAt: post.updatedAt,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 