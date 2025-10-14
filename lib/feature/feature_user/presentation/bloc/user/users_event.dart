
part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class UsersAllGetEvent extends UsersEvent {
  final int coachCode;
  UsersAllGetEvent(this.coachCode);
}
class UserGetEvent extends UsersEvent {
  final String userID;
  UserGetEvent(this.userID);
}
class UserCreateEvent extends UsersEvent {
  final UserModel user;
  UserCreateEvent(this.user);
}

class UserUpdateEvent extends UsersEvent {
  final UserModel updatedUser;
  UserUpdateEvent( this.updatedUser);
}
class UserCheckCoachCodeEvent extends UsersEvent{
  final int coachCode;
  UserCheckCoachCodeEvent(this.coachCode);
}

class DeleteUserEvent extends UsersEvent {
  final String phoneNumber;
  DeleteUserEvent(this.phoneNumber);
}

class LoginUserEvent extends UsersEvent {
  final String phoneNumber;
  final String password;
  LoginUserEvent({required this.phoneNumber, required this.password});
}