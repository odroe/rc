import 'context.dart';
import 'getter.dart';

class RuntimeConfiguration implements Getter {
  RuntimeConfiguration({
    required this.contents,
    this.root,
    this.environment = const <String, String>{},
  });

  /// Path type root prefix.
  final String? root;

  /// The configuration file contents.
  final String contents;

  /// Environment variables.
  final Map<String, String> environment;

  /// Current runtime configuration context.
  late final Context context;

  /// The parsed configuration.
  bool _isLoaded = false;

  /// Load the configuration file.
  void load() {
    if (_isLoaded == false) {
      context = Context(this)..parse();
    }

    _isLoaded = true;
  }

  @override
  T? call<T>(String key) => context<T>(key);

  @override
  bool has(String key) => context.has(key);

  @override
  String toString() => contents;
}
