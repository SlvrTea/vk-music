import 'package:hive_ce/hive.dart';

class User extends HiveObject {
  User({required this.accessToken, required this.userId, required this.secret});

  final String accessToken;
  final String userId;
  final String secret;

  factory User.fromJson(Map json) {
    return User(
      accessToken: json['access_token'] as String,
      userId: json['user_id'].toString(),
      secret: json['secret'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'access_token': accessToken, 'user_id': userId, 'secret': secret};

  @override
  String toString() => 'User(accessToken: $accessToken, userId: $userId, secret: $secret)';
}
