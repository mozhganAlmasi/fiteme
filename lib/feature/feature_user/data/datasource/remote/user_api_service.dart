import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shahrzad/feature/feature_user/data/model/usermodel.dart';
import '../../../../../core/constants.dart';


class UserApiService {

  static final String userBaseUrl = Constants.baseUrl + '/users';

  Future<http.Response> getAllUsers(int coachCode) async {
    try {
      final response = await http
          .get(Uri.parse('$userBaseUrl/listusers?coach_code=$coachCode'))
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('خطا در دریافت لیست کاربران');
    }
  }

  Future<http.Response> createUser(UserModel user) async {
    try {
      final response = await http
          .post(
            Uri.parse('$userBaseUrl/register'),
            headers: {'Content-Type': 'application/json'},

            body: json.encode(user.toJson()), // id ارسال نمی‌شود
          )
          .timeout(const Duration(seconds: 10));

      return response; // شناسه کاربر جدید
    } catch (e) {
      throw Exception('خطا در ایجاد کاربر جدید');
    }
  }

  Future<http.Response> updateUser(UserModel updatedUser) async {
    try {

      final response = await http.put(
        Uri.parse('$userBaseUrl/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUser.toJsonForUpdate()),
      );
      return response;
    } catch (e) {
      throw Exception('خطا در بروز رسانی اطلاعات کاربر');
    }
  }

  Future<http.Response> deleteUser(String phoneNumber) async {
    try {
      final response = await http.delete(
        Uri.parse('$userBaseUrl/delete'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phonenumber': phoneNumber}),
      );
      return response;
    } catch (e) {
      throw Exception('خطا در حذفت کاربر');
    }
  }

  Future<http.Response> getUser(String userid) async {
    try {
      final response = await http.get(
        Uri.parse('$userBaseUrl/getuser?id=$userid'),
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      throw Exception('خطا در دریافت اطلاعات کاربر ');
    }
  }

  Future<http.Response> login(String phoneNumber, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$userBaseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'phonenumber': phoneNumber,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response;
    } catch (e) {
      throw Exception('خطا در دسترسی به اطلاعات برای ورود کاربر');
    }
  }
}
