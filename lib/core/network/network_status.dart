abstract class NetworkStatus {
  Future<bool> hasInternetConnection();

  Stream<bool> get onStatusChanged;
}
