/// Not found exception.
class NotFoundException implements Exception {
  /// Create [NotFoundException] with [message].
  NotFoundException(this.message);

  /// The message of the exception.
  final String message;

  @override
  String toString() {
    return message;
  }
}
