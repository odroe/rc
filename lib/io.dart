import 'dart:io';

import 'package:path/path.dart' show join;

import 'src/runtime_configuration.dart';

/// Create a new [RuntimeConfiguration] for [File].
///
/// [root] default is [file.parent] directory.
///
/// [includeEnvironment] default is `true`, add [Platform.environment] to
/// [RuntimeConfiguration.environment].
RuntimeConfiguration createRuntimeConfigurationFromFile(
  File file, {
  String? root,
  Map<String, String>? environment,
  bool includeEnvironment = true,
}) {
  return RuntimeConfiguration(
    contents: file.readAsStringSync(),
    root: root ?? file.parent.path,
    environment: <String, String>{
      if (includeEnvironment) ...Platform.environment,
      if (environment != null) ...environment,
    },
  )..load();
}

/// Create a new [RuntimeConfiguration] for file at [path].
///
/// [path] default is `.rc`, if path not exists in [Directory.current]
/// and [root] is not null, then [path] is [root]/[path].
///
/// [root] default is [path] parent directory.
///
/// [includeEnvironment] default is `true`, add [Platform.environment] to
/// [RuntimeConfiguration.environment].
RuntimeConfiguration createRuntimeConfigurationFromPath({
  String path = '.rc',
  String? root,
  Map<String, String>? environment,
  bool includeEnvironment = true,
}) {
  File? file = File(path);
  // If file not exists and root is not null, then create file from root.
  if (!file.existsSync() && root != null) {
    file = File(join(root, path));
  }

  // If file not exists, then throw error.
  if (!file.existsSync()) {
    throw FileSystemException(
      'File not exists: ${file.path}',
      file.path,
    );
  }

  return createRuntimeConfigurationFromFile(
    File(path),
    root: root,
    environment: environment,
    includeEnvironment: includeEnvironment,
  );
}
