import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {

  UsersBloc() : super(UsersInitial()) {
    on<UsersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await UserRepository.getAllUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<GetUser>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await UserRepository.getUser(event.userID);
        emit(GetUserSuccess(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<CreateUserEvent>((event, emit) async {
      try {
        final userID= await UserRepository.createUser(event.user);
        emit(UserCreateSuccess(userID));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      try {
        await UserRepository.updateUser( event.updatedUser);
        emit(UpdateUserSuccess());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      try {
        await UserRepository.deleteUser(event.phoneNumber);
        emit(DeletUserSuccess());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<LoginSubmittedEvent>((event, emit) async {
      try {
        emit(UserLoading());
        var result =await UserRepository.login(event.phoneNumber ,event.password);
        if(result["success"] == true)
          {
            emit(UserLoginSuccess(result["user"]["id"]));
          }else{
          emit(UserLoginFail());
        }

      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
