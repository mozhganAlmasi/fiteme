class UserModel {
  final String? id; // nullable چون زمان ثبت هنوز موجود نیست
  final String name;
  final String family;
  final int groupid;
  final int role;
  final String email;
  final String phonenumber;
  final String password;
  final bool active;
  final int coach_code;

  UserModel({
    this.id,
    required this.name,
    required this.family,
    required this.groupid,
    required this.role,
    required this.email,
    required this.phonenumber,
    required this.password,
    required this.active,
    required this.coach_code,
  });

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
