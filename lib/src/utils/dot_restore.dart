import '_internal_utils.dart';

Object? dotRestore(value, {bool shouldWarn = true}) {
  return switch (value) {
    Map value => _restoreDottedMap(value, shouldWarn: shouldWarn),
    List value =>
      value.map((e) => dotRestore(e, shouldWarn: shouldWarn)).toList(),
    Set value =>
      value.map((e) => dotRestore(e, shouldWarn: shouldWarn)).toSet(),
    Iterable value => value.map((e) => dotRestore(e, shouldWarn: shouldWarn)),
    _ => value,
  };
}

Map _restoreDottedMap(Map value, {bool shouldWarn = true}) {
  final result = {};
  for (final key in value.keys) {
    if (key is! String || !key.contains('.')) {
      result[key] = dotRestore(value[key]);
      continue;
    }

    final keys = key.split('.').withoutEmptyChildren();
    if (keys.isEmpty) {
      if (shouldWarn) {
        warn(
            'Restore dotted map query found empty, key: $key, value: ${value[key]}');
      }
      continue;
    } else if (keys.length == 1) {
      result[keys.single] = dotRestore(value[key]);
      continue;
    }

    final [currentKey, ...childrenKeys] = keys.toList();
    if (result.containsKey(currentKey)) {
      continue;
    }

    final hasCollections = value.keys
        .any((e) => e is String && e.startsWith(currentKey) && e != currentKey);
    if (!hasCollections) {
      result[currentKey] =
          _wrapKeysValueMap(childrenKeys, value[key], shouldWarn: shouldWarn);
    }

    final collectionsEntries = value.entries
        .where((e) =>
            e.key is String &&
            e.key != currentKey &&
            (e.key as String).startsWith(currentKey))
        .map((e) => MapEntry(
            (e.key as String).substring(currentKey.length + 1), e.value));
    final collections = Map.fromEntries(collectionsEntries);

    result[currentKey] = dotRestore(collections);
  }

  return result;
}

Map<String, dynamic> _wrapKeysValueMap(Iterable<String> keys, value,
    {bool shouldWarn = true}) {
  assert(keys.length > 1);

  final [key, ...parent] = keys.toList().reversed.toList();

  Map<String, dynamic> current = {
    key: dotRestore(value, shouldWarn: shouldWarn)
  };

  for (final key in parent) {
    current = {key: current};
  }

  return current;
}
