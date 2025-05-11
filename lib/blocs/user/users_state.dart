part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitialState extends UsersState {}

class UserLoadingState extends UsersState {}

class UserLoadedState extends UsersState {
  final List<UserModel> users;
  UserLoadedState(this.users);
}
class GetUserSuccessState extends UsersState {
  UserModel user;
  GetUserSuccessState(this.user);
}
class DeletUserSuccessState extends UsersState {
}
class UpdateUserSuccessState extends UsersState {
}
class UserLoginSuccessState extends UsersState {
  final String userID ;
  final int userRole;
  UserLoginSuccessState(this.userID , this.userRole);
}
class UserLoginFailState extends UsersState {
}
class UserCreateSuccessState extends UsersState {
  final String userID ;
  UserCreateSuccessState(this.userID);
}
class UserErrorState extends UsersState {
  final String message;
  UserErrorState(this.message);
}
