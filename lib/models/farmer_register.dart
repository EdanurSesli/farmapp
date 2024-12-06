class FarmerRegister {
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? adress;
  final String password;

  FarmerRegister({
    this.firstName,
    this.lastName,
    required this.email,
    required this.userName,
    required this.adress,
    required this.password,
  });

  factory FarmerRegister.fromJson(Map<String, dynamic> json) {
    return FarmerRegister(
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      adress: json['adress'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'adress': adress,
      'password': password,
    };
  }
}
