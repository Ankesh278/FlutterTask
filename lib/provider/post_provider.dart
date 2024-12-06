import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/post_model.dart';

class PostProvider extends ChangeNotifier {
  List<Post> posts = [];
  Map<int, Timer?> postTimers = {};

  // Fetch all posts from local storage or API
  Future<void> fetchData() async {

    final prefs = await SharedPreferences.getInstance();
    final postsData = prefs.getString('posts_data');

    if (postsData != null) {
      // decode it from JSON and use it
      List<dynamic> data = json.decode(postsData);
      posts = data.map((json) => Post.fromJson(json)).toList();
      notifyListeners();
    } else {
      // no data exists, fetch from the API
      try {
        final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          posts = data.map((json) => Post.fromJson(json)).toList();

          // Save the fetched posts data
          prefs.setString('posts_data', json.encode(data));
          notifyListeners();
        } else {
          throw Exception('Failed to load posts');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching data: $e');
        }
      }
    }
  }

  // Fetch details of a specific post,
  // check local storage first
  Future<Post?> fetchPostDetails(int postId) async {
    final prefs = await SharedPreferences.getInstance();


    final postJson = prefs.getString('post_$postId');
    if (postJson != null) {
      // If post details are found in local storage, return it
      final postData = json.decode(postJson);
      return Post.fromJson(postData);
    } else {
      // If not found fetch the post from the API
      try {
        final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final post = Post.fromJson(data);

          // Save the fetched post to local storage
          prefs.setString('post_$postId', json.encode(data));

          return post;
        } else {
          throw Exception('Failed to load post details');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching post details: $e');
        }
        return null;
      }
    }
  }

  // Start a timer for the post
  void startTimer(int postId) {
    final post = posts.firstWhere(
          (post) => post.id == postId,
      orElse: () => Post.empty(),
    );
    if (post.remainingTime.inSeconds > 0) {
      postTimers[postId]?.cancel();
      postTimers[postId] = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (post.remainingTime.inSeconds <= 0) {
          timer.cancel();
          postTimers.remove(postId);
        } else {
          post.remainingTime -= const Duration(seconds: 1);
          notifyListeners();
        }
      });
    }
  }

  // Mark the post as read
  void markAsRead(int postId) {
    final post = posts.firstWhere(
          (post) => post.id == postId,
      orElse: () => Post.empty(),
    );
    if (post.id != 0) {
      post.isRead = true;
      notifyListeners();
    }
  }

  // Pause the timer for a specific post
  void pauseTimer(int postId) {
    postTimers[postId]?.cancel();
    postTimers.remove(postId);
    notifyListeners();
  }

  // Resume the timer for a specific post
  void resumeTimer(int postId) {
    startTimer(postId);
  }

  // Pause all timers
  void pauseAllTimers() {
    for (var timer in postTimers.values) {
      timer?.cancel();
    }
    postTimers.clear();
    notifyListeners();
  }
}
