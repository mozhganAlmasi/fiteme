import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_category/data/model/categorycreatemodel.dart';
import 'package:shahrzad/feature/feature_category/domain/repository/repository.dart';
import '../../data/model/category_model.dart';

class CategoryGetUseCase implements UseCase<  List<CategoryModel> ,int >{
  final CategoryRepository categoryRepository ;

  CategoryGetUseCase(this.categoryRepository);

  @override
  Future<List<CategoryModel>> call({required int params}) {
   return categoryRepository.getCategory(coachCode: params);
  }

}