// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? email;
  final String? username;
  final String? googleId;
  final String? facebookId;
  final String? appleId;
  final int isVerified;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final int countryId;
  final int isActive;
  final String role;
  final DateTime? accountVerificationTimeStamp;
  final DateTime? forgotPasswordTimeStamp;
  final String? accountVerificationOtp;
  final String? forgotPasswordOtp;
  final String? profilePicture;
  final int registrationType;

  UserDetailsModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.username,
    this.googleId,
    this.facebookId,
    this.appleId,
    required this.isVerified,
    this.firstName,
    this.lastName,
    this.phone,
    required this.countryId,
    required this.isActive,
    required this.role,
    this.accountVerificationTimeStamp,
    this.forgotPasswordTimeStamp,
    this.accountVerificationOtp,
    this.forgotPasswordOtp,
    this.profilePicture,
    required this.registrationType,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        email: json["email"] ?? "",
        username: json["username"] ?? "",
        googleId: json["googleId"] ?? "",
        facebookId: json["facebookId"] ?? "",
        appleId: json["appleId"] ?? "",
        isVerified: json["isVerified"],
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        phone: json["phone"] ?? "",
        countryId: json["countryId"],
        isActive: json["isActive"],
        role: json["role"],
        accountVerificationTimeStamp:
            json["accountVerificationTimeStamp"] == null ? DateTime.now() : DateTime.parse(json["accountVerificationTimeStamp"]),
        forgotPasswordTimeStamp: json["forgotPasswordTimeStamp"] == null ? DateTime.now() : DateTime.parse(json["forgotPasswordTimeStamp"]),
        accountVerificationOtp: json["accountVerificationOtp"] ?? "",
        forgotPasswordOtp: json["forgotPasswordOtp"] ?? "",
        profilePicture: json["profilePicture"] ?? "",
        registrationType: json["registrationType"],
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
        "accountVerificationTimeStamp": accountVerificationTimeStamp!.toIso8601String(),
        "forgotPasswordTimeStamp": forgotPasswordTimeStamp,
        "accountVerificationOtp": accountVerificationOtp,
        "forgotPasswordOtp": forgotPasswordOtp,
        "profilePicture": profilePicture,
        "registrationType": registrationType,
      };
}
