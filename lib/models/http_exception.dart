class HttpExtension implements Exception {
  HttpExtension({required this.message});

  final String message;

  @override
  String toString() {
    return message;
  }
}
