import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_category/data/model/categorycreatemodel.dart';
import 'package:shahrzad/feature/feature_category/domain/repository/repository.dart';

class CategoryCreateUseCase implements UseCase< int , CategoryCreateModel>{
  final CategoryRepository categoryRepository ;

  CategoryCreateUseCase(this.categoryRepository);

  @override
  Future<int> call({required CategoryCreateModel params}) {
    return categoryRepository.createCategory(categoryName: params.categoryName, coachCode: params.coachCode);
  }

}