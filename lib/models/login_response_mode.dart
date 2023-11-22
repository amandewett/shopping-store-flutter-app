import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String email;
  final dynamic username;
  final dynamic googleId;
  final dynamic facebookId;
  final dynamic appleId;
  final int isVerified;
  final String firstName;
  final String lastName;
  final String phone;
  final int countryId;
  final int isActive;
  final String role;
  final dynamic profilePicture;
  final int registrationType;
  final String token;

  LoginResponseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.username,
    required this.googleId,
    required this.facebookId,
    required this.appleId,
    required this.isVerified,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.countryId,
    required this.isActive,
    required this.role,
    required this.profilePicture,
    required this.registrationType,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        email: json["email"] ?? "",
        username: json["username"] ?? "",
        googleId: json["googleId"] ?? "",
        facebookId: json["facebookId"] ?? "",
        appleId: json["appleId"] ?? "",
        isVerified: json["isVerified"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        phone: json["phone"] ?? "",
        countryId: json["countryId"] ?? "",
        isActive: json["isActive"] ?? "",
        role: json["role"] ?? "",
        profilePicture: json["profilePicture"] ?? "",
        registrationType: json["registrationType"] ?? "",
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "email": email,
        "username": username,
        "googleId": googleId,
        "facebookId": facebookId,
        "appleId": appleId,
        "isVerified": isVerified,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "countryId": countryId,
        "isActive": isActive,
        "role": role,
        "profilePicture": profilePicture,
        "registrationType": registrationType,
        "token": token,
      };
}
