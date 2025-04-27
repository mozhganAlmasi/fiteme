import 'dart:convert';
import 'package:http/http.dart' as http;
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
 static final String baseUrl = 'https://almaseman.ir/api/users';

 static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/listusers'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['users'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<String> createUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json'
      },

      body: json.encode(user.toJson()), // id ارسال نمی‌شود
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
    final responseData = json.decode(response.body);
    return responseData['id']; // شناسه کاربر جدید
  }

  static Future<void> updateUser( UserModel updatedUser) async {
    final Map<String, dynamic> data = {
      'id': updatedUser.id,
      'name': updatedUser.name,
      'family': updatedUser.family,
      'email': updatedUser.email,
      'phonenumber': updatedUser.phoneNumber,
      'password' : updatedUser.password
    };
    final response = await http.put(
      Uri.parse('$baseUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  static Future<void> deleteUser(String phoneNumber) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$phoneNumber'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
 static Future<UserModel> getUser(String userid) async {
   final response = await http.get(
     Uri.parse('$baseUrl/getuser?id=$userid'),
     headers: {
       'Content-Type': 'application/json'
     }
   );
   if (response.statusCode != 200) {
     throw Exception('Failed to create user');
   }
   final responseData = json.decode(response.body);
   return UserModel.fromJson(responseData);
 }
  static Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phonenumber': phoneNumber,
        'password': password,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'user': data['user']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    }
  }
}
