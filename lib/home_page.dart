import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:task/post_details_screen.dart';
import 'package:task/provider/post_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchData();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("Task"),
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.posts.isEmpty) {
            return const Center(child: SpinKitThreeInOut(
              color: Colors.green,
              size: 50.0,
            ),);
          }
          return ListView.builder(
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final post = provider.posts[index];
              return VisibilityDetector(
                key: Key('post_$index'),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0) {
                    provider.startTimer(post.id);
                  } else {
                    provider.pauseTimer(post.id);
                  }
                },
                child: GestureDetector(
                  onTap: () async {
                    provider.pauseTimer(post.id);
                    provider.markAsRead(post.id);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailScreen(postId: post.id),
                      ),
                    );
                    provider.resumeTimer(post.id);
                  },
                  child: _buildPostCard(post),
                ),
              );
            },
          );
        },
      ),
    );
  }

  ///  card widget to display a single post...
  Widget _buildPostCard(post) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: post.isRead ? Colors.white : Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          // Timer display
          Positioned(
            top: 0,
            right: 0,
            child: Text(
              (post.remainingTime.inSeconds % 60).toString().padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
