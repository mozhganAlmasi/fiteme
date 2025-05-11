import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'userinfo_state.dart';

class UserinfoCubit extends Cubit<UserinfoState> {
  UserinfoCubit() : super(UserinfoInitial());

  void login(String userID, int userRole) {
    emit(UserinfoLoaded(userID: userID, userRole: userRole));
  }

  void logout() {
    emit(UserinfoLoggedOut());
  }
}
