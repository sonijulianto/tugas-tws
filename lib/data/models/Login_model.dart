class GetUser {
  final String username;
  final String password;

  GetUser({
    required this.username,
    required this.password,
  });

  factory GetUser.fromJson(Map<String, dynamic> json) {
    return GetUser(
      username: json['username'],
      password: json['password'],
    );
  }
}
