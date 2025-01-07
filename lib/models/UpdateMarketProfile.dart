class UpdateMarketProfile {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String adress;
  final String marketName;
  final String companyType;

  UpdateMarketProfile({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.adress,
    required this.marketName,
    required this.companyType,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'adress': adress,
      'marketName': marketName,
      'companyType': companyType,
    };
  }

  factory UpdateMarketProfile.fromJson(Map<String, dynamic> json) {
    return UpdateMarketProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      adress: json['adress'],
      marketName: json['marketName'],
      companyType: json['companyType'],
    );
  }
}
