import 'constants.dart';
import 'preset.dart';
import 'utils/dot.dart';

class RuntimeConfigure {
  final _storage = <String, dynamic>{};
  final _presets = <Preset>{};

  RuntimeConfigure({
    Map<String, dynamic>? init,
    Set<Preset>? presets,
    bool shouldWarn = true,
  }) {
    if (presets != null && presets.isNotEmpty) {
      for (final preset in presets) {
        use(preset);
      }
    }

    if (init != null && init.isNotEmpty) {
      _storage.addAll(init.dot());
    }

    _storage[shouldWarnKeys] = shouldWarn;
  }

  /// Returns a [T] typed value or `null`.
  T? call<T extends Object?>(String keys) {
    throw UnimplementedError();
  }

  /// Use a [Preset], If preset contains in current [RuntimeConfigure] skip it.
  void use(Preset preset) {
    if (_presets.contains(preset)) return;

    /// Register depends presets.
    for (final preset in preset.dependencies) {
      use(preset);
    }

    _presets.add(preset);
    _storage.addAll(preset.load().dot());
  }
}
