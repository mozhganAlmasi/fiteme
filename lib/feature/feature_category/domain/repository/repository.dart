import 'package:shahrzad/feature/feature_category/data/model/category_model.dart';

abstract class CategoryRepository{
  Future<List<CategoryModel>> getCategory({required int coachCode});
  Future<int> createCategory({required String categoryName,required int coachCode});
  Future <void> deletCategory({required int id});
}