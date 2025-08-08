part of 'sizes_bloc.dart';

@immutable
sealed class SizesEvent {}

class LoadingSize extends SizesEvent {

}

class LoadSizes extends SizesEvent {
  final String userID;
  LoadSizes(this.userID);
}

class CreateSize extends SizesEvent {
  final SizeModel size;
  CreateSize(this.size);
}

class UpdateSize extends SizesEvent {
  final String userID;
  final SizeModel updatedSize;
  UpdateSize(this.userID, this.updatedSize);
}

class DeleteSize extends SizesEvent {
  final String userID ;
  final int rowID;
  DeleteSize(this.userID , this.rowID) ;
}

class ErrorSizesEvent extends SizesEvent {}

