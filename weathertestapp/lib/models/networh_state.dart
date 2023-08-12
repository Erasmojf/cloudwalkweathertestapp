abstract class NetworkState {
  final int statusCode;
  final String message;

  NetworkState(this.message, this.statusCode);
}

class SuccessNetworkState extends NetworkState {
  final dynamic data;

  SuccessNetworkState(this.data) : super('Success', 200);
}

class FailureNetworkState extends NetworkState {
  FailureNetworkState(super.message, super.statusCode);
}
