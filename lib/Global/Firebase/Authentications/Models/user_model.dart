class UserModel {
  final String? id; // Add id field
  final String username;
  final String email;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id, // Include id in the JSON representation
      "username": username,
      "email": email,
    };
  }
}
