class MarketRegister {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? userName;
  final String adress;
  final String password;
  final String marketName;
  final String companyType;

  MarketRegister({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userName,
    required this.adress,
    required this.password,
    required this.marketName,
    required this.companyType,
  });

  factory MarketRegister.fromJson(Map<String, dynamic> json) {
    return MarketRegister(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      userName: json['userName'],
      adress: json['adress'],
      password: json['password'],
      marketName: json['marketName'],
      companyType: json['companyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userName': userName,
      'adress': adress,
      'password': password,
      'marketName': marketName,
      'companyType': companyType,
    };
  }
}
