import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';

class UserUpdateUseCase implements UseCase<void , UserModel>{
  final UsersRepository usersRepository;

  UserUpdateUseCase({required this.usersRepository});

  @override
  Future<void> call({required UserModel params}) {
    return usersRepository.updateUser(params);
  }
}