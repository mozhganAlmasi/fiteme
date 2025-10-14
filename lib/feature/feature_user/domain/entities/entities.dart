import 'package:equatable/equatable.dart';

class UserEntities extends Equatable{
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

  UserEntities(
      {required this.id, required this.name,required this.family,required this.groupid,required this.role,
        required  this.email,required this.phonenumber,required this.password,required this.active,
        required this.coach_code});

  @override
  // TODO: implement props
  List<Object?> get props =>[id ,name,family,groupid,role,email,phonenumber,password,active,coach_code,];


}