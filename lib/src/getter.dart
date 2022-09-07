abstract class Getter {
  /// Get a value from the runtime configuration.
  T? call<T>(String key);

  /// Check if the runtime configuration has a value for the key.
  bool has(String key);
}
