import 'dart:io';

import 'package:path/path.dart';

/// Path type
class Path {
  final String path;
  final String base;

  const Path(this.path, this.base);

  /// Parse the path.
  String parse() {
    // If path starts with `~`, replace it with the home directory.
    if (path.startsWith('~')) {
      return path.replaceFirst('~', Platform.environment['HOME'] ?? '');
    }

    final String configurationDirectory = dirname(base);
    final String parsedPath = join(configurationDirectory, path);

    return relative(parsedPath, from: Directory.current.path);
  }
}
