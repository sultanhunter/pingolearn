abstract class WordFailure {}

class WordFailureNotFound extends WordFailure {}

class WordFailureNoInternet extends WordFailure {}

class WordFailureApi extends WordFailure {
  final String? errorCode;

  WordFailureApi({this.errorCode});
}

class WordFailureNotAuthorized extends WordFailure {}
