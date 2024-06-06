// ignore_for_file: file_names

import 'rc.dart';
import 'utils/_logger.dart';
import 'utils/_utils.dart';

extension RC$Environment on RC {
  bool _envPartMatcher(MapEntry entry, bool skipDotiableKeys) {
    if (skipDotiableKeys && entry.key.contains('.')) {
      return false;
    }

    return switch (entry.value) {
      int() || double() || num() || BigInt() || DateTime() || String() => true,
      _ => false,
    };
  }

  /// Returns ENV parts of KV.
  Map<String, String> toEnvironmentMap({bool skipDotiableKeys = true}) {
    final entries = sources.entries
        .where((e) => _envPartMatcher(e, skipDotiableKeys))
        .map((e) => MapEntry(e.key, e.value.toString()));
    final environment = Map.fromEntries(entries);

    return Map.unmodifiable(environment);
  }

  /// Read the value of env and serialize it as a String?.
  String? env(String name) {
    if (name.contains('.') && shouldWarn(sources)) {
      warn(
          'The environment variable $name contains `.` symbols, please ignore warnings if intentionally used.');
    }

    return this<String>(name);
  }
}
