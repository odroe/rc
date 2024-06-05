import '../../loader.dart';

/// The dart `--define` configed environment preset.
class DefineLoader extends Loader {
  const DefineLoader();

  @override
  String? fallback(String keys) {
    if (bool.hasEnvironment(keys)) {
      return String.fromEnvironment(keys);
    }

    return null;
  }

  @override
  Map<String, dynamic> load({required bool shouldWarn}) => const {};
}
