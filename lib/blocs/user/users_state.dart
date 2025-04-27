part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

class UserLoading extends UsersState {}

class UserLoaded extends UsersState {
  final List<UserModel> users;
  UserLoaded(this.users);
}
class GetUserSuccess extends UsersState {
  UserModel user;
  GetUserSuccess(this.user);
}
class DeletUserSuccess extends UsersState {
}
class UpdateUserSuccess extends UsersState {
}
class UserLoginSuccess extends UsersState {
  final String userID ;
  UserLoginSuccess(this.userID);
}
class UserLoginFail extends UsersState {
}
class UserCreateSuccess extends UsersState {
  final String userID ;
  UserCreateSuccess(this.userID);
}
class UserError extends UsersState {
  final String message;
  UserError(this.message);
}
