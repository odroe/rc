import 'runtime_context.dart';
import 'getter.dart';

class RuntimeConfiguration implements Getter {
  RuntimeConfiguration({
    required this.contents,
    this.root,
    this.environment = const <String, String>{},
  }) {
    context = RuntimeContext(this);
  }

  /// Create a new [RuntimeConfiguration] from [path].
  external factory RuntimeConfiguration.from(
    String path, {
    String? root,
    Map<String, String>? environment,
    bool includeEnvironment = true,
  });

  /// Path type root prefix.
  final String? root;

  /// The configuration file contents.
  final String contents;

  /// Environment variables.
  final Map<String, String> environment;

  /// Current runtime configuration context.
  late final RuntimeContext context;

  @override
  T? call<T>(String key) => context<T>(key);

  @override
  bool has(String key) => context.has(key);

  @override
  Map<String, dynamic> get all => context.all;

  @override
  String toString() => contents;
}
