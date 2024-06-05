class InvalidLineError extends Error {
  final int number;
  final String line;

  InvalidLineError(this.number, this.line);
}
