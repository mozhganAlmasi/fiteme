part of 'sizes_bloc.dart';

@immutable
sealed class SizesState {}

final class SizesInitial extends SizesState {}
class SizeLoading extends SizesState {}
class SizeEmpty extends SizesState {}
class SizeCreateSuccess extends SizesState {}
class SizeDeletSuccess extends SizesState {
  int rowID;
  SizeDeletSuccess(this.rowID);
}
class SizeLoadSuccess extends SizesState {
  List<SizeModel> lstSize ;
  SizeLoadSuccess(this.lstSize);
}
class SizeFail extends SizesState {
  final String errMessage;
  SizeFail(String this.errMessage);
}