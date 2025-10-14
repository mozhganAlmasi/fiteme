import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';


class UserGetUseCase implements UseCase<UserModel , String>{
  final UsersRepository usersRepository;

  UserGetUseCase({required this.usersRepository});

  @override
  Future<UserModel> call({required String params}) {
    return usersRepository.getUser( params);
  }
}