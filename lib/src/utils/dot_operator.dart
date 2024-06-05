import '../constants.dart';

bool _shouldWarn(Map<String, dynamic> storage) {
  return switch (storage[shouldWarnKeys]) {
    bool value => value,
    _ => true,
  };
}

T? dotOperator<T extends Object?>(Map<String, dynamic> storage, String keys) {
  final dotted = storage.values.every((e) => switch (e) {
        Map() || Iterable() => false,
        _ => true,
      });
  if (!dotted) {
    throw ArgumentError.value(storage, 'storage' 'Must be dotted');
  }

  final hasCollections =
      storage.keys.any((e) => e.startsWith(keys) && e != keys);
  if (!hasCollections) {
    return switch (storage[keys]) {
      T value => value,
      Object value when value is T => value as T,
      Object value => _warn<T>(keys, value, _shouldWarn(storage)),
      _ => null,
    };
  }

  final collections =
      storage.entries.where((e) => e.key != keys && e.key.startsWith(keys));
  if (collections.isEmpty) return null;
}

T? _warn<T>(String keys, value, bool shouldWarn) {
  if (shouldWarn) {
    print(
        '⚠️ [odroe:rc] Found \'$keys\' with data type $T, expected ${value.runtimeType}');
  }

  return null;
}
