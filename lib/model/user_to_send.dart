class UserToSend {
  UserToSend(
      {required this.id,
      required this.name,
      required this.image,
      required this.accountType});

  final int id;
  final String name;
  final String image;
  final String accountType;
  factory UserToSend.fromJson(Map<String, dynamic> json) {
    return UserToSend(
        id: json['id'],
        name: json['user_name'],
        image: json['image'],
        accountType: json['account_type_name']);
  }
}
