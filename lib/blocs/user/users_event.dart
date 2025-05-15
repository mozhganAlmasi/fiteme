
part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class LoadUsersEvent extends UsersEvent {
  final int coachCode;
  LoadUsersEvent(this.coachCode);
}
class GetUserEvant extends UsersEvent {
  final String userID;
  GetUserEvant(this.userID);
}
class CreateUserEvent extends UsersEvent {
  final UserModel user;
  CreateUserEvent(this.user);
}

class UpdateUserEvent extends UsersEvent {
  final UserModel updatedUser;
  UpdateUserEvent( this.updatedUser);
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