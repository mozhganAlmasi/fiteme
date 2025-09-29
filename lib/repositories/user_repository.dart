import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shahrzad/core/constants.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

class UserRepository {
  static final String sizeBaseUrl = Constants.baseUrl + '/users';

  static Future<List<UserModel>> getAllUsers(int coachCode) async {
    try {
      final response = await http
          .get(Uri.parse('$sizeBaseUrl/listusers?coach_code=$coachCode'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        throw Exception('خطا در خواندن اطلاعات کاربر');
      }
    } catch (e) {
      throw Exception('خطا در خواندن اطلاعات کاربر');
    }
  }

  static Future<String> createUser(UserModel user) async {
    try {
      final response = await http
          .post(
            Uri.parse('$sizeBaseUrl/register'),
            headers: {'Content-Type': 'application/json'},

            body: json.encode(user.toJson()), // id ارسال نمی‌شود
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 400) {
        return "Duplicate ";
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

  static Future<void> updateUser(UserModel updatedUser) async {
    try {
      final Map<String, dynamic> data = {
        'id': updatedUser.id,
        'name': updatedUser.name,
        'family': updatedUser.family,
        'email': updatedUser.email,
        'groupid': updatedUser.groupid,
        'phonenumber': updatedUser.phonenumber,
        'password': updatedUser.password,
        'active': updatedUser.active,
      };
      final response = await http.put(
        Uri.parse('$sizeBaseUrl/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode != 200) {
        throw Exception('خطا در دسترسی به سرور برای بروزرسانی اطلاعات کاربر');
      }
    } catch (e) {
      throw Exception('خطا در بروز رسانی اطلاعات کاربر');
    }
  }

  static Future<void> deleteUser(String phoneNumber) async {
    try {
      final response = await http.delete(
        Uri.parse('$sizeBaseUrl/delete'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phonenumber': phoneNumber}),
      );
      if (response.statusCode != 200) {
        throw Exception('خطا در حذفت کاربر');
      }
    } catch (e) {
      throw Exception('خطا در حذفت کاربر');
    }
  }

  static Future<UserModel> getUser(String userid) async {
    try {
      final response = await http.get(
        Uri.parse('$sizeBaseUrl/getuser?id=$userid'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to get list users');
      }
      final responseData = json.decode(response.body);
      return UserModel.fromJson(responseData);
    } catch (e) {
      throw Exception('خطا در دریافت لیست کاربران ');
    }
  }

  static Future<Map<String, dynamic>> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$sizeBaseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'phonenumber': phoneNumber,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': data['user']};
      } else {
        return {'fail': false, 'message': data['message'] ?? 'Login failed'};
      }
    } on TimeoutException catch (e) {
      throw Exception('Timeout error: $e');
    } catch (e) {
      throw Exception('خطا در دسترسی به اطلاعات برای ورود کاربر');
    }
  }
}
