
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';

abstract class UsersRepository{
  Future<List<UserModel>> getAllUsers(int coachCode);
  Future<String> createUser(UserModel user);
  Future<void> updateUser(UserModel updatedUser);
  Future<void> deleteUser(String phoneNumber);
  Future<UserModel> getUser(String userid);
  Future<Map<String, dynamic>> login({required String phoneNumber,required String password}
      );

}