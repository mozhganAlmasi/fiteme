import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';


class UsersGetAllUseCase implements UseCase<List<UserModel> , int>{
  final UsersRepository usersRepository;

  UsersGetAllUseCase({required this.usersRepository});

  @override
  Future<List<UserModel>> call({required int params}) {
    return usersRepository.getAllUsers( params);
  }
}