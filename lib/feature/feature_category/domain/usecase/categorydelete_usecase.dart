import 'package:shahrzad/core/usecase/UseCase.dart';
import 'package:shahrzad/feature/feature_category/data/model/categorycreatemodel.dart';
import 'package:shahrzad/feature/feature_category/domain/repository/repository.dart';
import '../../data/model/category_model.dart';

class CategoryDeletUseCase implements UseCase<  void ,int >{
  final CategoryRepository categoryRepository ;

  CategoryDeletUseCase(this.categoryRepository);

  @override
  Future<void> call({required int params}) {
    return categoryRepository.deletCategory(id: params);
  }

}