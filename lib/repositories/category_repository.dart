import 'dart:convert';

import 'package:shahrzad/models/category_model.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class CategoryRepository {
  static final String categoryBaseUrl = Constants.baseUrl + '/category';

  static Future<List<CategoryModel>> getCategory(int coachCode) async {
    try {
      final uri = Uri.parse(
        '$categoryBaseUrl',
      ).replace(queryParameters: {'coachCode': coachCode.toString()});
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded.map((e) => CategoryModel.fromJson(e)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  static Future<int> createCategory(String categoryName, int coachCode) async {
    try {
      final response = await http
          .post(
            Uri.parse('$categoryBaseUrl/'),
            headers: {'Content-Type': 'application/json'},

            body: json.encode({
              'coachCode': coachCode,
              'categoryName': categoryName,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw Exception('خطا در دسترسی به سرور برای ساخت گروه بندی جدید');
      }
      //  final responseData = json.decode(response.body);
      return responseData['insertId']; // شناسه کاربر جدید
    } catch (e) {
      throw Exception('خطا در ایجاد گروه بندی جدید');
    }
  }

  static Future<void> deletCategory(int id) async {
    try {
      final uri = Uri.parse('$categoryBaseUrl');

      final response = await http
          .delete(
            uri,
            body: json.encode({'id': id}),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delet Category');
      }
    } catch (e) {
      throw Exception('Failed to delet Category');
    }
  }
}
