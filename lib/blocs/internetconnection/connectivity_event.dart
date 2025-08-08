
part of 'connectivity_bloc.dart';
@immutable
sealed class ConnectivityEvent {}
class CheckConnectivity extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final ConnectivityResult result;
  ConnectivityChanged(this.result);
}