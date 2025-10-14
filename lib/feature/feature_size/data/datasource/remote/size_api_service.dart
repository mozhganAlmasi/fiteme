import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/size_model.dart';

class SizeApiService{

  Future<http.Response> getUserSize(String baseUrl, String userID) async {
    final url = Uri.parse('$baseUrl/usersize');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userid': userID}),
    );
    return response;

  }
  Future<http.Response> deletUserSize(String baseUrl, String userID , int id) async {
    final uri = Uri.parse('$baseUrl/delete')
        .replace(queryParameters: {'userid': userID, 'id': id.toString()});
    final response = await http.delete(uri);
    return response;
  }

   Future<http.Response> insertSize(String baseUrl, SizeModel size) async {
    // تبدیل مدل به Map و حذف id (اگر لازم باشه)
    final Map<String, dynamic> data = size.toJson();

    final response = await http.post(
      Uri.parse('$baseUrl/insert'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

   return response;
  }


}