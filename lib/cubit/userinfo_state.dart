part of 'userinfo_cubit.dart';

@immutable
abstract class UserinfoState {}

class UserinfoInitial extends UserinfoState {}

class UserinfoLoaded extends UserinfoState {
  final String userID;
  final int userRole;
  final int coachCode;

  UserinfoLoaded({required this.userID, required this.userRole , required this.coachCode});
}

class UserinfoLoggedOut extends UserinfoState {}
