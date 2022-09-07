import 'dart:io';

import 'package:rc/io.dart';
import 'package:rc/rc.dart';

void printMessage(String first, dynamic last) =>
    print('${first.padRight(40)} -> $last');

/// String contents example.
void stringExample() {
  final String contents = '''
# One configuration.
one = This is one configuration.
two = \${one}
''';

  final rc = RuntimeConfiguration(contents: contents)..load();

  printMessage('one value', rc('one'));
  printMessage('one equals two', rc('one') == rc('two'));
}

/// File example.
void fileExample() {
  final rc = createRuntimeConfigurationFromFile(File('.rc'))..load();

  printMessage('path one', rc('path1'));
  printMessage('Int value', rc('int'));
  printMessage('Double value', rc('double'));
  printMessage('Bool value', rc('true'));
  printMessage('Null value', rc('null1'));
}

void main() {
  stringExample();
  fileExample();
}
