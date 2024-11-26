/// simple result class to handle success and error states
class Result<T> {
  final T? data;
  final String? error;

  Result({this.data, this.error});

  bool get isSuccess => error == null;
  bool get isFail => !isSuccess;

  @override
  String toString() => 'Result{data: $data, error: $error}';
}
