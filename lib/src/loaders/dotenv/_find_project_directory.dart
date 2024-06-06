import 'dart:io';

import 'package:path/path.dart' as path;

import '../../utils/_logger.dart';

Directory? findProjectDirectory(bool shouldWarn) =>
    _nestFindPubspecDirectory(File.fromUri(Platform.script).parent, shouldWarn);

Directory? _nestFindPubspecDirectory(Directory directory, bool shouldWarn) {
  try {
    final pubspec = File(path.join(directory.path, 'pubspec.yaml'));
    if (pubspec.existsSync()) return directory;
    if (_isOsRoot(directory)) return null;

    return _nestFindPubspecDirectory(directory.parent, shouldWarn);
  } catch (e) {
    if (shouldWarn) {
      warn(Error.safeToString(e));
    }

    return null;
  }
}

bool _isOsRoot(Directory directory) {
  if (Platform.isWindows) {
    return directory.path.endsWith(':\\');
  }

  return path.relative(directory.path, from: '/') == '.';
}
