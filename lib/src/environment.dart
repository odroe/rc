import 'dart:collection';
import '_internal/system_environment/system_environment.dart'
    as system_environment;

part '_internal/environment_impl.dart';

/// Runtime configuration.
///
/// The runtime configuration fork system environment variables and
/// allows you to override them.
///
/// **NOTE**: overrides are not applied to the system environment variables.
///
/// ```dart
/// import 'package:rc/rc.dart';
///
/// final Environment environment = Environment();
///
/// void main() {
///  environment['HOME'] = '/home/user';
///  environment['PATH'] = '/usr/bin:/usr/local/bin';
///
///  print(environment['HOME']); // /home/user
///  print(environment['PATH']); // /usr/bin:/usr/local/bin
/// }
/// ```
abstract class Environment extends MapBase<String, String> {
  /// Create a new [Environment] instance.
  ///
  /// - [environment]: initial overrides environment variables.
  /// - [includePlatformEnvironment]: include system environment variables.
  factory Environment({
    Map<String, String> environment,
    bool includePlatformEnvironment,
  }) = _EnvironmentImpl;

  /// Convert the [Environment] to a [key] case-insensitive [Environment].
  Environment toIgnoreCase();

  /// Convert the [Environment] to a [key] case-sensitive [Environment].
  Environment toCaseSensitive();
}
