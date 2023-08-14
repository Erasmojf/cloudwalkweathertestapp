abstract class NetworkState {
  final int statusCode;
  final String message;

  NetworkState(this.message, this.statusCode);
}

class SuccessNetworkState<T> extends NetworkState {
  final T data;

  SuccessNetworkState(this.data) : super('Success', 200);
}

class FailureNetworkState extends NetworkState {
  FailureNetworkState(super.message, super.statusCode);
}
