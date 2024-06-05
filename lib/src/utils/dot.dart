import 'flat.dart';
import '_internal_utils.dart';

Map<String, dynamic> _internalDotiableWithKeys(Iterable<String> keys, value) {
  if (value == null) return const {};

  final withoutEmptyKeys = keys.withoutEmptyChildren();

  return switch (value) {
    Map(_dotImpl: final dot) => dot(withoutEmptyKeys),
    Iterable(_dotImpl: final dot) => dot(withoutEmptyKeys),
    _ => {withoutEmptyKeys.join('.'): value},
  };
}

/// [Map] dotiable utils.
extension MapDot<K, V> on Map<K, V> {
  /// Returns flat with dot join keys.
  Map<String, dynamic> dot() => _dotImpl();

  /// Internal dot map impl.
  Map<String, dynamic> _dotImpl([Iterable<String>? parent]) {
    final entries = this
        .entries
        .map((e) =>
            _internalDotiableWithKeys([...?parent, e.key.toString()], e.value)
                .entries)
        .flat();

    return Map.fromEntries(entries);
  }
}

/// [Iterable] dotiable utils.
extension IterableDot<T> on Iterable<T> {
  /// Returns flat with dot join indexes.
  Map<String, dynamic> dot() => _dotImpl();

  /// Internal dot iterable impl.
  Map<String, dynamic> _dotImpl([Iterable<String>? parent]) {
    final entries = indexed
        .map((e) =>
            _internalDotiableWithKeys([...?parent, e.$1.toString()], e.$2)
                .entries)
        .flat();

    return Map.fromEntries(entries);
  }
}

/// Dotiable value
dynamic dotiable(value) {
  return switch (value) {
    Map(dot: final dot) => dot(),
    Iterable(dot: final dot) => dot(),
    _ => value,
  };
}
