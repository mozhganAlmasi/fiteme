class UserModel {
  final String? id; // nullable چون زمان ثبت هنوز موجود نیست
  final String name;
  final String family;
  final int groupId;
  final int role;
  final String email;
  final String phoneNumber;
  final String password;
  final bool active;
  final int coachCode;

  UserModel({
    this.id,
    required this.name,
    required this.family,
    required this.groupId,
    required this.role,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.active,
    required this.coachCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      family: json['family'],
      groupId: json['groupid'],
      role: json['role'],
      email: json['email'],
      phoneNumber: json['phonenumber'],
      password: json['password'],
      active: json['active'] == 1,
      coachCode: json['coach_code'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'family': family,
    'groupid': groupId,
    'role': role,
    'email': email,
    'phonenumber': phoneNumber,
    'password': password,
    'active': active,
    'coach_code': coachCode,
  };
}
