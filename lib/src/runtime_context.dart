import 'getter.dart';
import 'parser.dart';
import 'runtime_configuration.dart';

class RuntimeContext implements Getter {
  RuntimeContext(this.rc) {
    configuration = <String, dynamic>{
      ...rc.environment,
    };

    final Map<String, dynamic> collection = Parser(this).parse();
    for (final MapEntry<String, dynamic> element in collection.entries) {
      configuration[element.key] = element.value;
    }
  }

  /// Current runtime configuration.
  final RuntimeConfiguration rc;

  /// Get a value from the runtime configuration.
  late final Map<String, dynamic> configuration;

  @override
  Map<String, dynamic> get all => configuration;

  @override
  T? call<T>(String key) => all[key] as T?;

  @override
  bool has(String key) => all.containsKey(key);
}
