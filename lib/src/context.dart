import 'getter.dart';
import 'parser.dart';
import 'runtime_configuration.dart';

class Context implements Getter {
  Context(this.rc);

  /// Current runtime configuration.
  final RuntimeConfiguration rc;

  /// Get a value from the runtime configuration.
  late final Map<String, dynamic> configuration;

  @override
  T? call<T>(String key) => configuration[key] as T?;

  @override
  bool has(String key) => configuration.containsKey(key);

  /// Parse the runtime configuration.
  void parse() {
    configuration = <String, dynamic>{
      ...rc.environment,
      ...Parser(this).parse(),
    };
  }
}
