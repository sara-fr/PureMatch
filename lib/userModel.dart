// User object model class
class User {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String photo;
  final String marital_status;
  final String? joinedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    required this.photo,
    required this.marital_status,
    required this.joinedAt,
  });

  // Map users data from jsom to User model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      photo: json['photo'],
      marital_status: json['marital_status'],
      joinedAt: json['joinedAt'],
    );
  }
}