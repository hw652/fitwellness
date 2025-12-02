class CommunityPost {
  final String id;
  final String username;
  final String userImage;
  final DateTime createdAt;
  final String tag;
  final String content;
  final String? imageUrl;
  final bool isLocalImage; // To distinguish between network URL and local file path
  final int likes;
  final int comments;

  CommunityPost({
    required this.id,
    required this.username,
    required this.userImage,
    required this.createdAt,
    required this.tag,
    required this.content,
    this.imageUrl,
    this.isLocalImage = false,
    this.likes = 0,
    this.comments = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userImage': userImage,
      'createdAt': createdAt.toIso8601String(),
      'tag': tag,
      'content': content,
      'imageUrl': imageUrl,
      'isLocalImage': isLocalImage,
      'likes': likes,
      'comments': comments,
    };
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      username: json['username'],
      userImage: json['userImage'],
      createdAt: DateTime.parse(json['createdAt']),
      tag: json['tag'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      isLocalImage: json['isLocalImage'] ?? false,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }
}
