import 'constants.dart';
import 'context.dart';
import 'path.dart';

class Parser {
  Parser(this.context);

  /// Current runtime configuration context.
  final Context context;

  Map<String, dynamic> parse() {
    // Contents split by line.
    final List<String> lines = context.rc.contents.split(RegExp(r'\r?\n'))

      // Remove empty lines.
      ..removeWhere((line) => line.isEmpty)

      // Remove comments.
      ..removeWhere((line) => line.startsWith('#'));

    // Add key-value pairs to configuration.
    Map<String, dynamic> configuration = <String, dynamic>{};
    for (final String line in lines) {
      // Parse key and value.
      final List<String> parts = line.split('=');
      final String key = parts[0].trim();
      final String value = parts.length > 1 ? parts.sublist(1).join("=") : '';

      // Get line value type.
      final Type? type = _getType(key);

      // Get type removed key.
      final String typeRemovedKey = _removeKeyType(key);

      // If type is [Path], Set to configuration.
      if (type == Path) {
        configuration[typeRemovedKey] = Path(value.trim(), context);
        continue;
      }

      configuration[typeRemovedKey] = _parseTypedValue(type, value.trim());
    }

    // Parse variables and [Path].
    for (final MapEntry<String, dynamic> entry in configuration.entries) {
      if (entry.value is String) {
        configuration[entry.key] =
            _parseValueWithVeriables(configuration, entry.value);
      } else if (entry.value is Path) {
        configuration[entry.key] = _parsePath(configuration, entry.value);
      }
    }

    return configuration;
  }

  /// Parse [Path] with variables.
  String _parsePath(Map<String, dynamic> configuration, Path path) {
    final String parsedPath =
        _parseValueWithVeriables(configuration, path.path.trim());

    return Path(parsedPath.trim(), context).parse();
  }

  /// Parse value with variables.
  String _parseValueWithVeriables(
    Map<String, dynamic> configuration,
    String value,
  ) {
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
          configuration[variable] ?? context.configuration[variable];

      // If veriable is not found, skip it.
      if (variableValue == null) {
        continue;
      }

      final String veriableResult =
          _parseValueWithVeriables(configuration, variableValue.toString());

      result = result.replaceAll('\${$variable}', veriableResult);
    }

    return result;
  }

  /// Parse the typed value.
  dynamic _parseTypedValue(Type? type, String value) {
    final String trimmedValue = _removeTrailingComments(value).trim();

    switch (type) {
      case int:
        return int.parse(trimmedValue);
      case double:
        return double.parse(trimmedValue);
      case bool:
        return _parseBoolValue(trimmedValue);
      case String:
        return _removeStringBoundary(trimmedValue);
      case Null:
        return null;
    }

    // Dynamic type parse with value.
    return _parseDynamicValue(trimmedValue);
  }

  /// Remove trailing comments.
  String _removeTrailingComments(String line) {
    final int index = line.indexOf('#');

    if (index != -1) {
      return line.substring(0, index).trim();
    }

    return line.trim();
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

  /// Parse boolean value.
  bool _parseBoolValue(String value) {
    final String lowerCaseValue = value.toLowerCase().trim();

    if (lowerCaseValue == 'false' || lowerCaseValue == '0') {
      return false;
    }

    return true;
  }

  /// Remove key type from the key
  String _removeKeyType(String key) {
    final RegExp pattern = RegExp(r'(?<key>.+?)(\((?<type>\w+)\))?$');
    final RegExpMatch? match = pattern.firstMatch(key.trim());

    return match?.namedGroup('key')?.trim() ?? key.trim();
  }

  /// Get the type of the key
  Type? _getType(String key) {
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

    return null;
  }
}


//     // Parse value using variables.
//     current = current.map<String, dynamic>((String key, dynamic value) {
//       if (value is String) {
//         return MapEntry<String, dynamic>(key, _parseValueWithVeriables(value));
//       }

//       return MapEntry<String, dynamic>(key, value);
//     });

//     // Path type parse.
//     current = current.map<String, dynamic>((String key, dynamic value) {
//       final Type type = _getType(key);

//       if (type == Path) {
//         final String removedTypeKey = _removeKeyType(key);
//         final String parsedValye = Path(value.toString().trim(), path).parse();

//         return MapEntry<String, dynamic>(removedTypeKey, parsedValye);
//       }

//       return MapEntry<String, dynamic>(key, value);
//     });

//     // Add current to the configuration
//     configuration.addAll(current);
//   }


