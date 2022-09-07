import 'context.dart';
import 'utils/file_reader.dart';

abstract class RuntimeConfiguration {
  factory RuntimeConfiguration([String path = '.rc']) =>
      RuntimeConfigurationImpl(path);

  /// Runtime configuration file path.
  String get path;

  /// Get a value from the runtime configuration.
  T? call<T>(String key, [T? defaultValue]);

  /// Check if the runtime configuration has a value for the key.
  bool has(String key);
}

class RuntimeConfigurationImpl implements RuntimeConfiguration {
  const RuntimeConfigurationImpl.internal(this.context);

  factory RuntimeConfigurationImpl(String path) {
    // Create a new context
    final Context context = Context()
      // Set resolved configuration path
      ..path = path

      // Set configuration contents
      ..contents = fileReader(path)

      // Parse the configuration contents
      ..parse();

    return RuntimeConfigurationImpl.internal(context);
  }

  final Context context;

  /// Runtime configuration file path.
  @override
  String get path => context.path;

  /// Get a value from the runtime configuration.
  @override
  T? call<T>(String key, [T? defaultValue]) {
    if (has(key)) {
      return context.configuration[key] as T?;
    }

    return defaultValue;
  }

  /// Check if the runtime configuration has a value for the key.
  @override
  bool has(String key) => context.configuration.containsKey(key);

  /// To string.
  @override
  String toString() => context.contents;
}
