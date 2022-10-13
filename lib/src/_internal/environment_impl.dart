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
}
