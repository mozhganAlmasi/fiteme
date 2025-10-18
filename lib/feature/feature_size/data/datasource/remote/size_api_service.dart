import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../core/constants.dart';
import '../../model/size_model.dart';

class SizeApiService{
  static final String sizeBaseUrl = Constants.baseUrl + '/size';
  Future<http.Response> getUserSizeApi( String userID) async {
    final url = Uri.parse('$sizeBaseUrl/usersize');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userid': userID}),
    );
    return response;

  }
  Future<http.Response> deletUserSizeApi( String userID , int id) async {
    final uri = Uri.parse('$sizeBaseUrl/delete')
        .replace(queryParameters: {'userid': userID, 'id': id.toString()});
    final response = await http.delete(uri);
    return response;
  }

   Future<http.Response> insertSizeApi( SizeModel size) async {
    // تبدیل مدل به Map و حذف id (اگر لازم باشه)
    final Map<String, dynamic> data = size.toJson();

    final response = await http.post(
      Uri.parse('$sizeBaseUrl/insert'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

   return response;
  }


}