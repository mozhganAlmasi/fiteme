import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shahrzad/feature/feature_category/data/model/category_model.dart';

import '../../../../../core/constants.dart';

class CateoryApiService{
  static final String categoryBaseUrl = Constants.baseUrl + '/category';

  Future<http.Response> getCategoryApi ( int coachCode) async{
    try {
      final uri = Uri.parse(
        '$categoryBaseUrl',
      ).replace(queryParameters: {'coachCode': coachCode.toString()});
      final response = await http.get(uri);
      return response;
    } catch (e) {
      throw Exception('خطا در دریافت لیست کاربران');
    }
  }

  Future<http.Response> createCategory(String  categoryName , int coachCode) async {
    try {
      final response = await http
          .post(
        Uri.parse('$categoryBaseUrl/'),
        headers: {'Content-Type': 'application/json'},

        body: json.encode({
          'coachCode': coachCode,
          'categoryName': categoryName,
        }),
      ).timeout(const Duration(seconds: 10));
     return response;

    } catch (e) {
      throw Exception('خطا در ایجاد گروه بندی جدید');
    }

  }

  Future<http.Response> deletCategory(int id) async {
    try {
      final uri = Uri.parse('$categoryBaseUrl');

      final response = await http
          .delete(
        uri,
        body: json.encode({'id': id}),
        headers: {'Content-Type': 'application/json'},
      )
          .timeout(const Duration(seconds: 10));
     return response;
    } catch (e) {
      throw Exception('Failed to delet Category');
    }
  }
}