import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {

  UsersBloc() : super(UsersInitialState()) {
    on<UsersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadUsersEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final users = await UserRepository.getAllUsers(event.coachCode);
        emit(UserLoadedState(users));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<GetUserEvant>((event, emit) async {
      emit(UserLoadingState());
      try {
        final users = await UserRepository.getUser(event.userID);
        emit(GetUserSuccessState(users));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<CreateUserEvent>((event, emit) async {
      try {
        final userID= await UserRepository.createUser(event.user);
       if(userID == "Duplicate ")
           emit(UserDuplicate());
         else
           emit(UserCreateSuccessState(userID));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      try {
        await UserRepository.updateUser( event.updatedUser);
        emit(UpdateUserSuccessState());
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      try {
        await UserRepository.deleteUser(event.phoneNumber);
        emit(DeletUserSuccessState());
      } catch (e) {
        emit(DeletUserFailState(e.toString()));
      }
    });

    on<LoginSubmittedEvent>((event, emit) async {
      try {
        emit(UserLoadingState());
        var result =await UserRepository.login(event.phoneNumber ,event.password);
        if(result["success"] == true)
          {
            emit(UserLoginSuccessState(UserModel.fromJson(result["user"])));
          }else{
          emit(UserLoginFailState());
        }

      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
