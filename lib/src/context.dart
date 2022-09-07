import 'getter.dart';
import 'parser.dart';
import 'runtime_configuration.dart';

class Context implements Getter {
  Context(this.rc);

  /// Current runtime configuration.
  final RuntimeConfiguration rc;

  /// Get a value from the runtime configuration.
  final Map<String, dynamic> configuration = <String, dynamic>{};

  @override
  T? call<T>(String key) => configuration[key] as T?;

  @override
  bool has(String key) => configuration.containsKey(key);

  /// Parse the runtime configuration.
  void parse() {
    // Add environment variables.
    configuration.addAll(rc.environment);

    // Add the parsed configuration.
    configuration.addAll(Parser(this).parse());
  }
}
