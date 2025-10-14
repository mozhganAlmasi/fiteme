import 'dart:convert';

import 'package:shahrzad/feature/feature_user/data/datasource/remote/user_api_service.dart';
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';


class UserRepositoryImplementation implements UsersRepository {
  final UserApiService apiService;

  UserRepositoryImplementation({required this.apiService});

  @override
  Future<String> createUser(UserModel user) async{
    try {
      final response =await apiService.createUser(user);
      if (response.statusCode == 400) {
        return "Duplicate";
      }
      if (response.statusCode == 401) {
        return "coachDuplicate";
      }
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw Exception('خطا در دسترسی به سرور برای ساخت کاربر جدید');
      }
      //  final responseData = json.decode(response.body);
      return responseData['id']; // شناسه کاربر جدید
    } catch (e) {
      throw Exception('خطا در ایجاد کاربر جدید');
    }
  }

  @override
  Future<void> deleteUser(String phoneNumber) async{
    try {
      final response = await apiService.deleteUser(phoneNumber);
      if (response.statusCode != 200) {
        throw Exception('خطا در حذفت کاربر');
      }
    } catch (e) {
      throw Exception('خطا در حذفت کاربر');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers(int coachCode) async {
    try {
      final response = await apiService.getAllUsers(coachCode);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        throw Exception('خطا در دریافت لیست کاربران');
      }
    } catch (e) {
      throw Exception('خطا در دریافت لیست کاربران');
    }
  }

  @override
  Future<UserModel> getUser(String userid) async {
    try {
      final response = await apiService.getUser(userid);
      if (response.statusCode != 200) {
        throw Exception('Failed to get user');
      }
      final responseData = json.decode(response.body);
      return UserModel.fromJson(responseData);
    } catch (e) {
      throw Exception('خطا در دریافت اطلاعات کاربر ');
    }
  }

  @override
  Future<Map<String, dynamic>> login({required String phoneNumber, required String password}) async{
    try {
      final response = await apiService.login(phoneNumber, password);

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': data['user']};
      } else {
        return {'fail': false, 'message': data['message'] ?? 'Login failed'};
      }
    }  catch (e) {
      throw Exception('خطا در دسترسی به اطلاعات برای ورود کاربر');
    }
  }

  @override
  Future<void> updateUser(UserModel updatedUser) async{
    try {
      final response = await apiService.updateUser(updatedUser);
      if (response.statusCode != 200) {
        throw Exception('خطا در دسترسی به سرور برای بروزرسانی اطلاعات کاربر');
      }
    } catch (e) {
      throw Exception('خطا در بروز رسانی اطلاعات کاربر');
    }
  }
}
