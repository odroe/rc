/// Dot env parser.
abstract interface class Parser {
  const Parser();

  /// Parse dot env.
  Map<String, String> parse(
      {required Iterable<String> lines, required bool shouldWarn});
}
