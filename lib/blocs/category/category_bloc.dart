import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shahrzad/models/category_model.dart';
import 'package:shahrzad/repositories/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ResetCategoryEvent>((event, emit) {
      emit(CategoryInitial()); // یا هر استیت اولیه‌ای که داری
    });

    on<LoadCategoryEvent>((event , emit) async{
      emit(CategoryLoadingState());
      try{
           List<CategoryModel> listCategories = await CategoryRepository.getCategory(event.coachCode);
           emit(CategoryLoadSuccessState(listCategories));
      }
      catch(e)
      {
        emit(CategoryLoadFailState());
      }
    });
    on<AddCategoryEvent> ((event , emit) async{
      try{
        emit(CategoryLoadingState());
         int id =  await CategoryRepository.createCategory(event.categoryName, event.caochCOde);
         emit(CategoryCreateSuccess(id));

      }catch (e){

      }
    });

    on<DeletCategoryEvent>((event , emit) async{
      try{
        emit(CategoryLoadingState());
        await CategoryRepository.deletCategory(event.id);
        emit(CategoryDeletSuccessState());
      }catch(e){
        emit(CategoryDeletFailState());
      }
    });
  }
}
