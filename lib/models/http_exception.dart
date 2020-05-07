class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}

// .toString() normally just prints 'Instance of x' etc. but in class Exception it is overridden
// with another .toString() behavior.
