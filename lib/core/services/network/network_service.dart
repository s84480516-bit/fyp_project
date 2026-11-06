import 'package:connectivity_plus/connectivity_plus.dart';

/// Network Info Class for checking connectivity
class NetworkService {
  final Connectivity _connectivity;

  NetworkService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  Stream<List<ConnectivityResult>> get connectionStream {
    return _connectivity.onConnectivityChanged;
  }
}
