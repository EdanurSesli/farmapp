class UpdateFarmerProfile {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String adress;

  UpdateFarmerProfile({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.adress,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'adress': adress,
    };
  }

  factory UpdateFarmerProfile.fromJson(Map<String, dynamic> json) {
    return UpdateFarmerProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
      adress: json['adress'],
    );
  }
}
