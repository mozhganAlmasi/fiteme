part of 'sizes_bloc.dart';

@immutable
sealed class SizesEvent {}

class SizeLoadingEvent extends SizesEvent {

}

class SizesLoadEvent extends SizesEvent {
  final String userID;
  SizesLoadEvent(this.userID);
}

class SizeCreateEvent extends SizesEvent {
  final SizeModel Size;
  SizeCreateEvent(this.Size);
}

class SizeUpdateEvent extends SizesEvent {
  final String userID;
  final SizeModel updatedSize;
  SizeUpdateEvent(this.userID, this.updatedSize);
}

class SizeDeletEvent extends SizesEvent {
  final String userID ;
  final int rowID;
  SizeDeletEvent(this.userID , this.rowID) ;
}

class ErrorSizesEvent extends SizesEvent {}

