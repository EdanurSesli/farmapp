class Login {
  final String userName;
  final String password;

  Login({required this.userName, required this.password});

  /// Login modelini JSON formatına çevirir
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
  final String userName; // Kullanıcı adı eklenebilir
  final List<String> roles;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    required this.emailConfirmed,
    required this.userName, // Yeni alan
    required this.roles,
  });

  /// API'den gelen JSON'u LoginResponse modeline çevirir
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '', // Varsayılan değer olarak boş string
      userId: json['userId'] ?? 0, // Varsayılan değer olarak 0
      email: json['email'] ?? '', // Varsayılan değer olarak boş string
      emailConfirmed: json['emailConfirmed'] ?? false, // Varsayılan false
      userName: json['userName'] ?? '', // Varsayılan değer olarak boş string
      roles: List<String>.from(json['roles'] ?? []), // Varsayılan boş liste
    );
  }

  /// LoginResponse modelini JSON formatına çevirir
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
