import '../../loader.dart';

/// The dart `--define` configed environment preset.
class DartDefine extends Loader {
  const DartDefine();

  @override
  Map<String, dynamic> load() => const {};

  @override
  String? fallback(String keys) {
    if (bool.hasEnvironment(keys)) {
      return String.fromEnvironment(keys);
    }

    return null;
  }
}
