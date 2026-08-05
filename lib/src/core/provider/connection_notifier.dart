import 'dart:async';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connection_notifier.g.dart';

@Riverpod(keepAlive: true)
class ConnectionNotifier extends _$ConnectionNotifier {
  late Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  bool build() {
    _connectivity = Connectivity();
    // Listen to connection changes
    _subscription = _connectivity.onConnectivityChanged.listen((_) async {
      final hasInternet = await _checkInternetAccess();
      state = hasInternet;
    });

    // Emit current status on startup
    _connectivity.checkConnectivity().then((result) async {
      final hasInternet = await _checkInternetAccess();
      state = hasInternet;
    });

    // Cancel subscription when disposed
    ref.onDispose(() {
      _subscription?.cancel();
      _subscription = null;
    });

    return true;
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
