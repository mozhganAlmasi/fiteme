part of 'sizes_bloc.dart';

@immutable
sealed class SizesState {}

final class SizesInitial extends SizesState {}
class SizeLoading extends SizesState {}
class SizeEmpty extends SizesState {}
class SizeCreateSuccess extends SizesState {}
class SizeCreateFail extends SizesState {
  final String errMessage;
  SizeCreateFail(String this.errMessage);
}
class SizeDeletSuccess extends SizesState {
  int rowID;
  SizeDeletSuccess(this.rowID);
}
class SizeDeleteFail extends SizesState{
  String msg;
  SizeDeleteFail(this.msg);
}
class SizeLoadSuccess extends SizesState {
  List<SizeModel> lstSize ;
  SizeLoadSuccess(this.lstSize);
}
class SizeLoadFail extends SizesState {
  final String errMessage;
  SizeLoadFail(String this.errMessage);
}