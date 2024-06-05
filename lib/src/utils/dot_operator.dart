import '_utils.dart';
import 'dot_restore.dart';

T? dotOperator<T>(Map<String, dynamic> storage, String keys) {
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
    return warnTypeCast<T>(keys, storage[keys], shouldWarn(storage));
  }

  final collections = storage.entries
      .where((e) => e.key != keys && e.key.startsWith(keys))
      .map((e) => MapEntry(e.key.substring(keys.length + 1), e.value));
  if (collections.isEmpty) return null;

  final result = dotRestore(Map.fromEntries(collections));

  return warnTypeCast<T>(keys, result, shouldWarn(storage));
}
