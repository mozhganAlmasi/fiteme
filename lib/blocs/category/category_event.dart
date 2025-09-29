part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class LoadCategoryEvent extends CategoryEvent{
  final int coachCode ;

  LoadCategoryEvent(this.coachCode);
}

class AddCategoryEvent extends CategoryEvent{
  final int caochCOde;
  final String categoryName;

  AddCategoryEvent(this.caochCOde, this.categoryName);
}

class EditCategoryEvent extends CategoryEvent{
  final int caochCOde;
  final String categoryNewName;

  EditCategoryEvent(this.caochCOde, this.categoryNewName);
}

class DeletCategoryEvent extends CategoryEvent{
  final int id;

  DeletCategoryEvent(this.id);
}
class ResetCategoryEvent extends CategoryEvent {}