/// Iterable flat utils.
extension IterableFlat<T> on Iterable<Iterable<T>> {
  /// Returns a flattened values.
  Iterable<T> flat() => expand((e) => e);
}
