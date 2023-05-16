class User {
  User({
    required this.token,
    required this.type,
  });
  final String token;
  final int type;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
    };
  }
}
