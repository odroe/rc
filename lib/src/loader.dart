/// Configuration loader
abstract class Loader {
  const Loader();

  /// Load the configurations.
  Map<String, dynamic> load({required bool shouldWarn});

  /// The regression query for configuration not found during runtime configuration.
  Object? fallback(String keys) => null;

  /// Define other loaders that the [Loader] depends on.
  ///
  /// The dependent loader will load data before the current [Loader], and the [fallback] behavior will also be after the current [Loader].
  Set<Loader> get dependencies => const {};
}
