import 'dart:io' show Platform;

/// IO system environment.
///
/// **NOTE**: Environment variables are read from the `dart:io` library.
final Map<String, String> environment = Platform.environment;
