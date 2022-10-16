part of '../environment.dart';

/// Environment implementation.
class _EnvironmentImpl extends MapBase<String, String> implements Environment {
  /// Create a new [EnvironmentImpl] instance.
  _EnvironmentImpl({
    Map<String, String>? environment,
    bool includePlatformEnvironment = true,
  }) {
    // Initialize environment variables.
    _environment = <String, String>{
      if (includePlatformEnvironment) ...system_environment.environment,
      if (environment != null) ...environment,
    };
  }

  /// Internal environment store.
  late final Map<String, String> _environment;

  @override
  String? operator [](Object? key) => _environment[key];

  @override
  void operator []=(String key, String value) => _environment[key] = value;

  @override
  void clear() => _environment.clear();

  @override
  Iterable<String> get keys => _environment.keys;

  @override
  String? remove(Object? key) => _environment.remove(key);

  @override
  Environment toIgnoreCase() => _IgnoreCaseEnvironmentImpl(this);

  @override
  Environment toCaseSensitive() => this;
}

/// Ignore case environment implementation.
class _IgnoreCaseEnvironmentImpl extends MapBase<String, String>
    implements Environment {
  /// Create a new [IgnoreCaseEnvironmentImpl] instance.
  _IgnoreCaseEnvironmentImpl(this._environment);

  /// Internal environment store.
  final Environment _environment;

  @override
  String? operator [](Object? key) => entry(key)?.value;

  @override
  void operator []=(String key, String value) =>
      _environment[entry(key)?.key ?? key] = value;

  @override
  void clear() => _environment.clear();

  @override
  Iterable<String> get keys => _environment.keys;

  @override
  String? remove(Object? key) => _environment.remove(entry(key)?.key ?? key);

  @override
  Environment toIgnoreCase() => this;

  @override
  bool containsKey(Object? key) => entry(key) != null;

  /// Returns a [MapEntry<String, String>?], case-insensitive.
  MapEntry<String, String>? entry(Object? key) {
    final String? trimmed = key?.toString().toLowerCase().trim();
    for (final MapEntry<String, String> entry in _environment.entries) {
      if (entry.key.toLowerCase().trim() == trimmed) {
        return entry;
      }
    }

    return null;
  }

  @override
  Environment toCaseSensitive() => _environment;
}
