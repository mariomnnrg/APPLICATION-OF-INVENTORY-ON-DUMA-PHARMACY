class User {
  final int? id;
  final String? email;
  final String? name;
  final String? password;
  final int? role;

  User({this.id, this.email, this.name, this.password, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        role: json['role']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "role": role,
    };
  }
}