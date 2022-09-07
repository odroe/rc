import 'dart:io';

import 'parser.dart';

class Context {
  late final String path;
  late final String contents;
  final Map<String, dynamic> configuration = <String, dynamic>{};

  /// Parse the configuration contents.
  void parse() {
    // Add all environment variables to the configuration
    configuration.addAll(Platform.environment);

    final Parser parser = Parser(
      contents: contents,
      configuration: configuration,
      path: path,
    );
    parser.parse();
  }
}
