part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitialState extends UsersState {}

class UserLoadingState extends UsersState {}

class UserLoadedState extends UsersState {
  final List<UserModel> users;
  UserLoadedState(this.users);
}
class UserGetSuccessState extends UsersState {
  UserModel user;
  UserGetSuccessState(this.user);
}
class UserDeletSuccessState extends UsersState {
}
class UserDeletFailState extends UsersState {
  String msg;
  UserDeletFailState(this.msg);
}
class UpdateUserSuccessState extends UsersState {
}
class UserLoginSuccessState extends UsersState {
  final UserModel user ;
  UserLoginSuccessState(this.user);
}
class UserLoginFailState extends UsersState {
}
class UserCreateSuccessState extends UsersState {
  final String userID ;
  UserCreateSuccessState(this.userID);
}
class UserDuplicate extends UsersState{

}
class UserErrorState extends UsersState {
  final String message;
  UserErrorState(this.message);
}
