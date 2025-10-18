import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shahrzad/feature/feature_category/data/model/category_model.dart';
import 'package:shahrzad/feature/feature_category/data/model/categorycreatemodel.dart';
import 'package:shahrzad/feature/feature_category/domain/usecase/categorycreate_usecase.dart';
import 'package:shahrzad/feature/feature_category/domain/usecase/categorydelete_usecase.dart';
import 'package:shahrzad/feature/feature_category/domain/usecase/categoryget_usecase.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryCreateUseCase categoryCreateUseCase;
  CategoryGetUseCase categoryGetUseCase;
  CategoryDeletUseCase categoryDeletUseCase;

  CategoryBloc({
    required this.categoryCreateUseCase,
    required this.categoryGetUseCase,
    required this.categoryDeletUseCase,
  }) : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ResetCategoryEvent>((event, emit) {
      emit(CategoryInitial()); // یا هر استیت اولیه‌ای که داری
    });

    on<LoadCategoryEvent>((event, emit) async {
      emit(CategoryLoadingState());
      try {
        List<CategoryModel> listCategories = await categoryGetUseCase(
          params: event.coachCode,
        );
        emit(CategoryLoadSuccessState(listCategories));
      } catch (e) {
        emit(CategoryLoadFailState());
      }
    });
    on<AddCategoryEvent>((event, emit) async {
      try {
        emit(CategoryLoadingState());
        CategoryCreateModel temp = CategoryCreateModel(
          categoryName: event.categoryName,
          coachCode: event.caochCOde,
        );
        int id = await categoryCreateUseCase(params: temp);
        emit(CategoryCreateSuccess(id));
      } catch (e) {}
    });

    on<DeletCategoryEvent>((event, emit) async {
      try {
        emit(CategoryLoadingState());
        await categoryDeletUseCase(params:event.id);
        emit(CategoryDeletSuccessState());
      } catch (e) {
        emit(CategoryDeletFailState());
      }
    });
  }
}
