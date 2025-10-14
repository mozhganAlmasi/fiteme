import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';

class UserCreateUseCase implements UseCase<String , UserModel>{
  final UsersRepository usersRepository;

  UserCreateUseCase({required this.usersRepository});

  @override
  Future<String> call({required UserModel params}) {
    return usersRepository.createUser(params);
  }
}