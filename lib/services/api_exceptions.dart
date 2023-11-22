class AppExceptions {
  final String message;
  final String prefix;
  final String endpoint;

  AppExceptions(
    this.message,
    this.prefix,
    this.endpoint,
  );
}

class BadRequestException extends AppExceptions {
  BadRequestException(String message, String endpoint) : super(message, 'Bad Request', endpoint);
}

class FetchDataException extends AppExceptions {
  FetchDataException(String message, String endpoint) : super(message, 'Unable to process', endpoint);
}

class ApiNotRespondingException extends AppExceptions {
  ApiNotRespondingException(String message, String endpoint) : super(message, 'Api not responded in time', endpoint);
}

class UnAuthorizedException extends AppExceptions {
  UnAuthorizedException(String message, String endpoint) : super(message, 'UnAuthorized request', endpoint);
}
