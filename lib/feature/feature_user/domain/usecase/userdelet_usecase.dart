import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';

class UserDeletUseCase implements UseCase<void , String>{
  final UsersRepository usersRepository;

  UserDeletUseCase({required this.usersRepository});

  @override
  Future<void> call({required String params}) {
    return usersRepository.deleteUser(params);
  }
}