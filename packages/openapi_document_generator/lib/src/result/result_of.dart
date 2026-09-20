sealed class const ResultOf<S, F>() {
  factory Success(S data) {
    return SuccessOf(data);
  }

  factory Failure(F failure) {
    return FailureOf(failure);
  }
}

final class const FailureOf<Success, Failure>(final Failure failure)
    extends ResultOf<Success, Failure> {}

final class const SuccessOf<Success, Failure>(final Success data)
    extends ResultOf<Success, Failure> {}
