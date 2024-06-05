import '_invalid_line_error.dart';
import 'parser.dart';

class DefaultParser implements Parser {
  const DefaultParser();

  @override
  Map<String, String> parse(
      {required Iterable<String> lines, required bool shouldWarn}) {
    final environment = <String, String>{};
    for (final (number, line) in lines.indexed) {
      final normalizeLine = line.trim();
      if (normalizeLine.isEmpty || normalizeLine.startsWith('#')) {
        continue;
      }

      final parts = normalizeLine.split('=').map((e) => e.trim());
      if (parts.length < 2) {
        throw InvalidLineError(number, line);
      }

      final key = parts.elementAt(0).trim();
      final value = parts
          .skip(1)
          .join('=')
          .split('#')
          .first
          .trim()
          .trimQuotationMarks()
          .tranUnicode();

      environment[key] = value;
    }

    return environment;
  }
}

extension on String {
  String trimQuotationMarks() {
    if (startsWith('\'') && endsWith('\'') && length > 1) {
      return substring(1, length - 1);
    }

    if (startsWith('"') && endsWith('"') && length > 1) {
      return substring(1, length - 1);
    }

    return this;
  }

  static final unicodePattern = RegExp(r'\\u\{([0-9a-fA-F]+)\}');
  String tranUnicode() => replaceAllMapped(unicodePattern, (match) {
        final charCode = int.parse(match.group(1)!, radix: 16);

        return String.fromCharCode(charCode);
      });
}
