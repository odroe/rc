import '_internal_utils.dart';

Object? dotRestore(value) {
  return switch (value) {
    Map value => _restoreDottedMap(value),
    _ => value,
  };
}

Map _restoreDottedMap(Map value) {
  final shouldParse = value.keys.any((e) => e is String && e.contains('.'));
  if (!shouldParse) return value;

  final result = {};
  for (final MapEntry(key: key, value: value) in value.entries) {
    if (key is! String || !key.contains('.')) {
      result[key] = dotRestore(value);
      continue;
    }

    final keys = key.split('.').withoutEmptyChildren();
    if (keys.isEmpty) {}
  }
}
