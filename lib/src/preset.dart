/// Preset configuration loader
abstract class Preset {
  const Preset();

  /// Load the preset configurations.
  Map<String, dynamic> load();

  /// The regression query for configuration not found during runtime configuration.
  Object? fallback(String keys) => null;

  /// Define other presets that the [Preset] depends on.
  ///
  /// The dependent preset will load data before the current [Preset], and the [fallback] behavior will also be after the current [Preset].
  Set<Preset> get dependencies => const {};
}
