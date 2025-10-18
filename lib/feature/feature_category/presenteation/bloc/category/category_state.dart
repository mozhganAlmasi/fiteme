part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadSuccessState extends CategoryState {
  final List<CategoryModel> categiries;

  CategoryLoadSuccessState(this.categiries);
}

class CategoryCreateSuccess extends CategoryState {
  final int id;

  CategoryCreateSuccess(this.id);
}

class CategoryLoadFailState extends CategoryState {}

class CategoryDeletSuccessState extends CategoryState {
}

class CategoryDeletFailState extends CategoryState {}

class CategoryEditSuccessState extends CategoryState {}

class CategoryEditFailState extends CategoryState {}
