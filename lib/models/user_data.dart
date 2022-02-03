class UserData {
  final String userId;
  final String lastName;
  final String firstName;

  const UserData({
    required this.userId,
    required this.lastName,
    required this.firstName,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['id'],
      lastName: json['last_name'],
      firstName: json['first_name'],
    );
  }
}
