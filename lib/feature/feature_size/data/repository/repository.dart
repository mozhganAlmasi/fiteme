import 'dart:convert';
import 'package:shahrzad/feature/feature_size/data/datasource/remote/size_api_service.dart';
import 'package:shahrzad/feature/feature_size/data/model/size_model.dart';
import 'package:shahrzad/feature/feature_size/domain/repository/repositories.dart';
import 'package:http/http.dart' as http;

class SizeRepositoryImpementation implements SizeRepository{
  final SizeApiService apiService;
  SizeRepositoryImpementation({required this.apiService});

  @override
  Future<List<SizeModel>> getSize(String userID) async{
    try{
      final response = await apiService.getUserSizeApi( userID);
      if (response.statusCode == 200) {
        // درخواست موفق بود
        final List data = json.decode(response.body);
        return data.map((e) => SizeModel.fromJson(e)).toList();

      } else {
        // درخواست خطا داشت، می‌توانید خطا را هندل کنید یا خطا پرتاب کنید
        throw Exception('خطا در دریافت داده از سرور: ${response.statusCode}');
      }
    }catch(e)
    {
      throw Exception('Failed to load size');
    }

  }

  @override
  Future<bool> deletSize(String userID, int id) async{
     final response = await apiService.deletUserSizeApi( userID, id);
     if (response.statusCode != 200) {
       throw Exception('Failed to delet size');
     }
     return true;
  }

  @override
  Future<bool> createSize(SizeModel size) async{
    final response =await apiService.insertSizeApi(size);
    if (response.statusCode != 200) {
      throw Exception('Failed to create size');
    }
    return true;
  }

}