import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/loginparams.dart';

class UserLoginUseCase implements UseCase<Map<String, dynamic> , LoginUserParams>{
  final UsersRepository usersRepository;

  UserLoginUseCase({required this.usersRepository});

  @override
  Future<Map<String, dynamic>> call({required LoginUserParams params}) {
    return usersRepository.login( phoneNumber: params.phonenumber ,password: params.password );
  }
}