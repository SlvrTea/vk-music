
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(1)
  final String accessToken;
  @HiveField(2)
  final String userId;
  @HiveField(3)
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

  @override
  String toString() =>
      'User(accessToken: $accessToken, userId: $userId, secret: $secret)';
}
