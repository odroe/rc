import 'constants.dart';
import 'typed_path.dart';

class Parser {
  final String contents;
  final Map<String, dynamic> configuration;
  final String path;

  Parser({
    required this.contents,
    required this.configuration,
    required this.path,
  });

  late List<String> lines;
  Map<String, dynamic> current = <String, dynamic>{};

  /// Parse the configuration contents.
  void parse() {
    lines = contents.split(RegExp(r'\r?\n'));

    // Remove empty lines
    lines.removeWhere((String line) => line.trim().isEmpty);

    // Remove comments
    lines.removeWhere((String line) => line.trim().startsWith('#'));

    // Remove trailing comments
    lines = lines.map(_removeTrailingComments).toList();

    // Add key-value pairs to the current
    for (final String line in lines) {
      _addKeyValuePair(line);
    }

    // Parse key-value types
    current = current.map<String, dynamic>((String key, dynamic value) {
      final Type type = _getType(key);

      // Skip `Path` type.
      if (type == Path) {
        return MapEntry<String, dynamic>(key, value);
      }

      final String removedTypeKey = _removeKeyType(key);
      final dynamic typedValue =
          _parseTypedValue(type, value.toString().trim());

      return MapEntry<String, dynamic>(removedTypeKey, typedValue);
    });

    // Parse value using variables.
    current = current.map<String, dynamic>((String key, dynamic value) {
      if (value is String) {
        return MapEntry<String, dynamic>(key, _parseValueWithVeriables(value));
      }

      return MapEntry<String, dynamic>(key, value);
    });

    // Path type parse.
    current = current.map<String, dynamic>((String key, dynamic value) {
      final Type type = _getType(key);

      if (type == Path) {
        final String removedTypeKey = _removeKeyType(key);
        final String parsedValye = Path(value.toString().trim(), path).parse();

        return MapEntry<String, dynamic>(removedTypeKey, parsedValye);
      }

      return MapEntry<String, dynamic>(key, value);
    });

    // Add current to the configuration
    configuration.addAll(current);
  }

  /// Parse value with variables.
  String _parseValueWithVeriables(String value) {
    // Find all variables
    // Example:
    // Hello, ${word} -> ['word']
    // Hello, ${word} ${word2} -> ['word', 'word2']
    // ${HOME} -> ['HOME']
    // lib/${HOME}/lib -> ['HOME']
    final RegExp pattern = RegExp(r'\${(?<variable>\w+)}');
    final Iterable<RegExpMatch> matches = pattern.allMatches(value);

    // If there are no variables, return the value.
    if (matches.isEmpty) {
      return value;
    }

    // Replace all variables with their values.
    String result = value;
    for (final RegExpMatch match in matches) {
      final String? variable = match.namedGroup('variable');
      if (variable == null) {
        continue;
      }

      final dynamic variableValue =
          current[variable] ?? configuration[variable];

      // If veriable is not found, skip it.
      if (variableValue == null) {
        continue;
      }

      final String veriableResult =
          _parseValueWithVeriables(variableValue.toString());
      result = result.replaceAll('\${$variable}', veriableResult);
    }

    return result;
  }

  /// Parse the typed value.
  dynamic _parseTypedValue(Type type, String value) {
    switch (type) {
      case int:
        return int.parse(value);
      case double:
        return double.parse(value);
      case bool:
        return _parseBoolValue(value);
      case String:
        return _removeStringBoundary(value);
      case Null:
        return null;
    }

    // Dynamic type parse with value.
    return _parseDynamicValue(value);
  }

  /// Parse the dynamic value.
  dynamic _parseDynamicValue(String value) {
    // If value is empty, return null
    if (value.isEmpty) {
      return null;
    }

    // Parse the value as a bool
    if (value == 'true' || value == 'false') {
      return _parseBoolValue(value);
    }

    // Parse the value as a number
    final int? intValue = int.tryParse(value);
    if (intValue?.toString() == value) {
      return intValue;
    }

    // Parse the value as a double
    final double? doubleValue = double.tryParse(value);
    if (doubleValue?.toString() == value) {
      return doubleValue;
    }

    return _removeStringBoundary(value);
  }

  /// Parse boolean value.
  bool _parseBoolValue(String value) {
    final String lowerCaseValue = value.toLowerCase().trim();

    if (lowerCaseValue == 'false' || lowerCaseValue == '0') {
      return false;
    }

    return true;
  }

  /// Remove the boundary of the string
  String _removeStringBoundary(String value) {
    // If start with ' or " and end with ' or "
    // Remove the boundary of the string.
    if (value.startsWith("'") && value.endsWith("'")) {
      return value.substring(1, value.length - 1);
    }

    if (value.startsWith('"') && value.endsWith('"')) {
      return value.substring(1, value.length - 1);
    }

    return value;
  }

  /// Remove key type from the key
  String _removeKeyType(String key) {
    // Find key pattern.
    // Example:
    // key -> key
    // key(int) -> key
    // key(string) -> key
    final RegExp pattern = RegExp(r'(?<key>.+?)(\((?<type>\w+)\))?$');
    final RegExpMatch? match = pattern.firstMatch(key.trim());

    return match?.namedGroup('key')?.trim() ?? key.trim();
  }

  /// Get the type of the key
  Type _getType(String key) {
    final String types = supportedTypes.join('|');
    final RegExp pattern = RegExp('\\((?<type>$types)\\)\$');
    final String? matched = pattern.firstMatch(key.trim())?.namedGroup('type');

    switch (matched?.toLowerCase()) {
      case 'null':
        return Null;
      case 'bool':
        return bool;
      case 'int':
        return int;
      case 'double':
        return double;
      case 'string':
        return String;
      case 'path':
        return Path;
    }

    return dynamic;
  }

  /// Add a key-value pair to the configuration.
  void _addKeyValuePair(String line) {
    final List<String> parts = line.split('=');
    final String key = parts[0].trim();
    final String value = parts.length > 1 ? parts.sublist(1).join("=") : '';

    current[key] = value.trim();
  }

  /// Remove trailing comments.
  String _removeTrailingComments(String line) {
    final int index = line.indexOf('#');

    if (index != -1) {
      return line.substring(0, index);
    }

    return line;
  }
}
