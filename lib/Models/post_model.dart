class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  bool isRead;
  Duration remainingTime;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    this.remainingTime = const Duration(minutes: 1),
  });


  Post.empty()
      : userId = 0,
        id = 0,
        title = '',
        body = '',
        isRead = false,
        remainingTime = Duration.zero;


  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
