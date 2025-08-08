import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';


class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late final StreamSubscription _subscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        add(ConnectivityChanged(results.first));
      }
    });
  }

  Future<void> _onCheckConnectivity(
      CheckConnectivity event, Emitter<ConnectivityState> emit) async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }
  }

  void _onConnectivityChanged(
      ConnectivityChanged event, Emitter<ConnectivityState> emit) {
    if (event.result == ConnectivityResult.mobile || event.result == ConnectivityResult.wifi) {
      emit(ConnectivityConnected());
    } else {
      emit(ConnectivityDisconnected());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
