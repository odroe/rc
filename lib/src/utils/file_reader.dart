import 'dart:io';

String fileReader(String path) {
  final StringBuffer contents = StringBuffer();
  final File file = File(path);
  if (file.existsSync()) {
    contents.write(file.readAsStringSync());
  }

  return contents.toString();
}
