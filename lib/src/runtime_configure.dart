import 'constants.dart';
import 'preset.dart';
import 'utils/_internal_utils.dart';
import 'utils/dot.dart';
import 'utils/dot_operator.dart';

class RuntimeConfigure {
  final _storage = <String, dynamic>{};
  final _presets = <Preset>[];

  RuntimeConfigure({
    Map<String, dynamic>? init,
    Set<Preset>? presets,
    bool shouldWarn = true,
  }) {
    _storage[shouldWarnKeys] = shouldWarn;

    if (init != null && init.isNotEmpty) {
      for (final MapEntry(key: keys, value: value) in init.dot().entries) {
        set(keys, value);
      }
    }

    if (presets != null && presets.isNotEmpty) {
      for (final preset in presets) {
        use(preset);
      }
    }
  }

  /// Returns a [T] typed value or `null`.
  ///
  /// Example:
  /// ```dart
  /// final debug = config('app.debug'); // Read the { "app": { "debug": <value> } }
  /// ```
  T? call<T>(String keys) {
    final cleanedKeys = keys.trimDots();
    final result = dotOperator<T>(_storage, cleanedKeys);
    if (result != null) return result;

    Object? value;
    for (final preset in _presets.reversed) {
      final result = preset.fallback(cleanedKeys);
      if (result is T) return result;
      if (result != null) value = result;
    }

    if (value != null) {
      return warnTypeCast(cleanedKeys, value, shouldWarn(_storage));
    }

    return null;
  }

  /// Use a [Preset], If preset contains in current [RuntimeConfigure] skip it.
  void use(Preset preset) {
    if (_presets.contains(preset)) return;

    /// Register depends presets.
    for (final preset in preset.dependencies) {
      use(preset);
    }

    _presets.add(preset);
    for (final MapEntry(key: keys, value: value)
        in preset.load().dot().entries) {
      set(keys, value);
    }
  }

  /// Sets a [value] by dotiable keys.
  ///
  /// Example:
  /// ```dart
  /// config.set('a.b.c', true); // Update value { "a": { "b": { "c": true } } }
  /// ```
  void set<T>(String keys, T value) {
    final cleanedKeys = keys.trimDots();
    final result = switch (dotiable(value)) {
      Map(entries: final entries) => entries
          .map((e) => ('$cleanedKeys.${e.key.toString().trimDots()}', e.value)),
      Iterable(indexed: final indexed) =>
        indexed.map((e) => ('$cleanedKeys.${e.$1}', e.$2)),
      dynamic value => [(cleanedKeys, value)],
    };

    delete(cleanedKeys);
    for (final (key, value) in result) {
      _storage[key] = value;
    }
  }

  /// Updates a value by dotiable keys with [updater] callbacl.
  ///
  /// Example:
  /// ```dart
  /// config.update<bool>('a.b', (value) => value != true ? true : false);
  /// ```
  void update<T>(String keys, T Function(T? value) updater) {
    set(keys, updater(this<T>(keys)));
  }

  /// Delete value by [keys] in current runtime configure.
  void delete(String keys) {
    final cleanedKeys = keys.trimDots();
    _storage.removeWhere(
        (key, _) => cleanedKeys == key || key.startsWith(cleanedKeys));
  }
}

extension on String {
  String trimDots() => trimLeftDots().trimRightDots();

  String trimLeftDots() {
    if (startsWith('.')) return substring(1).trimLeftDots();
    return this;
  }

  String trimRightDots() {
    if (endsWith('.')) return substring(0, length - 1).trimRightDots();
    return this;
  }
}
