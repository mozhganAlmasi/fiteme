import 'dart:convert';

import 'package:shahrzad/feature/feature_category/data/datasource/remote/category_api_services.dart';
import 'package:shahrzad/feature/feature_category/data/model/category_model.dart';
import 'package:shahrzad/feature/feature_category/domain/repository/repository.dart';

class CategoryRepositoryImpelementation implements CategoryRepository{

  CateoryApiService cateoryApiService;

  CategoryRepositoryImpelementation(this.cateoryApiService);

  @override
  Future<List<CategoryModel>> getCategory({required int coachCode}) async{
    try {

      final response = await cateoryApiService.getCategoryApi( coachCode);
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

  @override
  Future<int> createCategory({required String categoryName, required int coachCode}) async{
    try {
      final response =await cateoryApiService.createCategory(categoryName, coachCode);
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
  @override
  Future<void> deletCategory({required int id}) async {
    try {
      final response =await cateoryApiService.deletCategory(id);
      if (response.statusCode != 200) {
        throw Exception('Failed to delet Category');
      }
    } catch (e) {
      throw Exception('Failed to delet Category');
    }
  }

}