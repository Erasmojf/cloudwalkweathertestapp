abstract class AppState {
  final String? message;

  AppState(this.message);
}

class InitAppState extends AppState {
  InitAppState() : super('');
}

class LoadingAppState extends AppState {
  LoadingAppState() : super('Loading');
}

class EmptyAppState extends AppState {
  EmptyAppState() : super('Empty data');
}

class SuccessAppState<T> extends AppState {
  final T data;

  SuccessAppState(this.data) : super('');
}

class FailureAppState extends AppState {
  FailureAppState(super.message);
}
