import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shahrzad/core/constants.dart';
import 'package:shahrzad/models/size_model.dart';

class SizeRepository {
  static final String userBaseUrl = Constants.baseUrl + '/size';

  static Future<List<SizeModel>> fetchSize(String userID) async {
    try {
      final response = await http
          .post(
            Uri.parse('$userBaseUrl/usersize'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'userid': userID}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        print('Raw response: ${response.body}');
        print('Decoded: ${json.decode(response.body)}');
        return data.map((e) => SizeModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load size');
      }
    } catch (e) {
      throw Exception('Failed to load size');
    }
  }

  static Future<void> createSize(SizeModel size) async {
    try {
      final response = await http
          .post(
            Uri.parse('$userBaseUrl/insert'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(size.toJson()), // id ارسال نمی‌شود
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception('Failed to create size');
      }
    } catch (e) {
      throw Exception('Failed to create size');
    }
  }

  static Future<void> deletSize(String userID, int id) async {
    try {
      final uri = Uri.parse(
        '$userBaseUrl/delete',
      ).replace(queryParameters: {'userid': userID, 'id': id.toString()});

      final response = await http
          .delete(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delet size');
      }
    } catch (e) {
      throw Exception('Failed to delet size');
    }
  }
}
