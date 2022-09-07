import 'package:path/path.dart' show relative;

import 'context.dart';

/// Path type
class Path {
  final String path;
  final Context context;

  const Path(this.path, this.context);

  /// Parse path.
  String parse() {
    // If path start with ~, replace with home directory.
    if (path.startsWith('~')) {
      return path.replaceFirst('~', context.rc.environment['HOME'] ?? '');
    }

    return relative(path, from: context.rc.root);
  }
}
