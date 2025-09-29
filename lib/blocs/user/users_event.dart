
part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class UsersLoadEvent extends UsersEvent {
  final int coachCode;
  UsersLoadEvent(this.coachCode);
}
class UserGetEvant extends UsersEvent {
  final String userID;
  UserGetEvant(this.userID);
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

class LoginSubmittedEvent extends UsersEvent {
  final String phoneNumber;
  final String password;
  LoginSubmittedEvent({required this.phoneNumber, required this.password});
}