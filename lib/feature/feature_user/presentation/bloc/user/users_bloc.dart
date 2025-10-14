import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/loginparams.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userdelet_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userget_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/usercreate_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userlogin_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userupdate_usecase.dart';

import '../../../domain/usecase/usersgetall_usecaase.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersGetAllUseCase getUsersUseCase;
  final UserGetUseCase getUserUseCase;
  final UserCreateUseCase userCreateUseCase;
  final UserDeletUseCase userDeletUseCase;
  final UserLoginUseCase userLoginUseCase;
  final UserUpdateUseCase userUpdateUseCase;

  UsersBloc({
    required this.userDeletUseCase,
    required this.userLoginUseCase,
    required this.userUpdateUseCase,
    required this.getUsersUseCase,
    required this.getUserUseCase,
    required this.userCreateUseCase,
  }) : super(UsersInitialState()) {
    on<UsersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<UsersAllGetEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final users = await getUsersUseCase(params: event.coachCode);
        emit(UserLoadedState(users));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<UserGetEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final users = await getUserUseCase(params: event.userID);
        emit(UserGetSuccessState(users));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<UserCreateEvent>((event, emit) async {
      try {
        emit(UserLoadingState());
        final duplicate = await userCreateUseCase(params: event.user);
        if (duplicate == "Duplicate")
          emit(UserDuplicate());
        else if (duplicate == "coachDuplicate")
          emit(CoachDuplicate());
        else
          emit(UserCreateSuccessState(duplicate));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<UserUpdateEvent>((event, emit) async {
      try {
        await userUpdateUseCase(params: event.updatedUser);
        emit(UpdateUserSuccessState());
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      try {
        await userDeletUseCase(params: event.phoneNumber);
        emit(UserDeletSuccessState());
      } catch (e) {
        emit(UserDeletFailState(e.toString()));
      }
    });

    on<LoginUserEvent>((event, emit) async {
      try {
        emit(UserLoadingState());
        final params=LoginUserParams(phonenumber:  event.phoneNumber,password:  event.password);
        var result = await userLoginUseCase(params: params);
        if (result["success"] == true) {
          emit(UserLoginSuccessState(UserModel.fromJson(result["user"])));
        } else {
          emit(UserLoginFailState());
        }
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }

  Future<void> _onGetUserEvent(
    UserGetEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UserLoadingState());
    try {
      final users = await getUserUseCase(params: event.userID);
      emit(UserGetSuccessState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
