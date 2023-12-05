class User {
  final String accessToken;
  final String userId;
  final String secret;

  const User({
    required this.accessToken,
    required this.userId, 
    required this.secret
  });

  factory User.fromJson(Map json) {
    return User(
      accessToken: json['access_token'] as String,
      userId: json['user_id'].toString(),
      secret: json['secret'] as String
    );
  }
}
