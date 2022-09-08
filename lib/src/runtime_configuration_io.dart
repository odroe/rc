import 'dart:io';

import 'package:path/path.dart' show join, dirname;

import 'runtime_configuration.dart' as internal;

/// Resolve path
String? _resolvePath(String path, [String? root]) {
  // If file exists in [Directory.current], then return path.
  if (File(path).existsSync()) return path;

  // If root is not null.
  if (root != null) return _resolvePath(join(root, path), null);

  // Default return null.
  return null;
}

class RuntimeConfiguration extends internal.RuntimeConfiguration {
  RuntimeConfiguration({
    required super.contents,
    super.root,
    super.environment,
  });

  factory RuntimeConfiguration.from(
    String path, {
    String? root,
    Map<String, String>? environment,
    bool includeEnvironment = true,
  }) {
    assert(path.isNotEmpty, 'path must not be empty');

    // Resolve path.
    final String? resolvedPath = _resolvePath(path, root);
    assert(resolvedPath != null, 'File not exists: $path');

    // Read file.
    final String contents = File(resolvedPath!).readAsStringSync();

    // Create runtime configuration.
    return RuntimeConfiguration(
      contents: contents,
      root: root ?? dirname(resolvedPath),
      environment: <String, String>{
        if (includeEnvironment) ...Platform.environment,
        if (environment != null) ...environment,
      },
    );
  }
}
