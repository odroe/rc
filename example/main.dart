import 'dart:io';

import 'package:rc/rc.dart';

void main() {
  final File exampleFile = File('.rc');
  final RuntimeConfiguration examplerc = RuntimeConfiguration(
    contents: exampleFile.readAsStringSync(),
    environment: Platform.environment,
  )..load();

  print(examplerc);
}
