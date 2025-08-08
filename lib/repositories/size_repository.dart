import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shahrzad/models/size_model.dart';

class SizeRepository {
 static final String baseUrl = 'https://almaseman.ir/api/size';

 static Future<List<SizeModel>> fetchSize(String userID) async {
    final response = await http.post(
        Uri.parse('$baseUrl/usersize'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userid': userID}),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      print('Raw response: ${response.body}');
      print('Decoded: ${json.decode(response.body)}');
      return data.map((e) => SizeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load size');
    }
  }

  static Future<void> createSize(SizeModel size) async {
    final response = await http.post(
      Uri.parse('$baseUrl/insert'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(size.toJson()), // id ارسال نمی‌شود
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create size');
    }
  }


 static Future<void> deletSize(String userID , int id) async {
   final uri = Uri.parse('$baseUrl/delete')
       .replace(queryParameters: {'userid': userID, 'id': id.toString()});

   final response = await http.delete(uri);

   if (response.statusCode != 200) {
     throw Exception('Failed to delet size');
   }
 }

}
