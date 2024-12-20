class Login {
  final String userName;
  final String password;

  Login({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final int userId;
  final String email;
  final bool emailConfirmed;
  final String userName;
  final List<String> roles;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    required this.emailConfirmed,
    required this.userName,
    required this.roles,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? 0,
      email: json['email'] ?? '',
      emailConfirmed: json['emailConfirmed'] ?? false,
      userName: json['userName'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'emailConfirmed': emailConfirmed,
      'userName': userName,
      'roles': roles,
    };
  }
}
