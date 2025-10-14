import 'package:shahrzad/feature/feature_user/domain/entities/entities.dart';

class UserModel extends UserEntities {
  UserModel({
    required id,
    required name,
    required family,
    required groupid,
    required role,
    required email,
    required phonenumber,
    required password,
    required active,
    required coach_code,

  }) : super(
         id: id,
         name: name,
         family: family,
         groupid: groupid,
         role: role,
         email: email,
         phonenumber: phonenumber,
         password: password,
         active: active,
         coach_code: coach_code,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      groupid: json['groupid'],
      role: json['role'],
      email: json['email'],
      phonenumber: json['phonenumber'],
      password: json['password'],
      active: json['active'] == 1,
      coach_code: json['coach_code'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'family': family,
    'groupid': groupid,
    'role': role,
    'email': email,
    'phonenumber': phonenumber,
    'password': password,
    'active': active,
    'coach_code': coach_code,
  };
}
