import 'dart:io';

import 'package:path/path.dart' as path;

import '../../loader.dart';
import '../../utils/_logger.dart';
import '../environment/environment_loader.dart';
import '_find_project_directory.dart';
import '_invalid_line_error.dart';
import 'default_parser.dart';
import 'parser.dart';

class DotenvLoader extends Loader {
  /// Skip multiple locations of a file.
  ///
  /// If a file is specified in files and the same file is found in multiple search directories, if [skipMultipleLocations] is true, it will be skipped. Otherwise, all files found in different locations for the same file will be loaded.
  final bool skipMultipleLocations;

  /// Load dot env files.
  final Iterable<String> files;

  /// Include system environment
  final bool includeSystemEnvironment;

  /// Search files in project directory.
  final bool searchProjectDirectory;

  /// Files search directories.
  final Iterable<String>? searchDirectories;

  /// Dot env file parser.
  final Parser parser;

  const DotenvLoader({
    this.skipMultipleLocations = true,
    this.includeSystemEnvironment = true,
    this.files = const ['.env'],
    this.searchProjectDirectory = true,
    this.searchDirectories,
    this.parser = const DefaultParser(),
  });

  @override
  get dependencies => switch (includeSystemEnvironment) {
        true => const {EnvironmentLoader()},
        _ => super.dependencies,
      };

  @override
  Map<String, dynamic> load({required bool shouldWarn}) {
    final environment = <String, String>{};
    final searchDirectories = _searchDirectories(shouldWarn);

    for (final filename in files.toSet()) {
      for (final directory in searchDirectories) {
        try {
          final file = File(path.join(directory, filename));
          if (!file.existsSync()) continue;

          final lines = file.readAsLinesSync();
          final results = parser.parse(lines: lines, shouldWarn: shouldWarn);

          environment.addAll(results);

          if (skipMultipleLocations) break;
        } catch (e) {
          if (shouldWarn) {
            final message = switch (e) {
              InvalidLineError e =>
                'Invalid line in "${path.relative(path.join(directory, filename))}"'
                    'file: L${e.number} ${e.line}',
              _ => Error.safeToString(e),
            };

            warn(message);
          }

          continue;
        }
      }
    }

    return environment;
  }

  Iterable<String> _searchDirectories(bool shouldWarn) {
    final directories = <int, String>{};
    for (final directory in searchDirectories ?? [Directory.current.path]) {
      final relativeDirectory = path.relative(directory);
      final hash = path.hash(relativeDirectory);

      if (directories.containsKey(hash)) continue;
      directories[hash] = relativeDirectory;
    }

    final projectDirectory = findProjectDirectory(shouldWarn);
    if (projectDirectory != null) {
      final directory = path.relative(projectDirectory.path);
      final hash = path.hash(directory);

      if (!directories.containsKey(hash)) {
        directories[hash] = directory;
      }
    }

    return directories.values;
  }
}
