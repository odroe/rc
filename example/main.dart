import 'package:rc/rc.dart';

void main() {
  final config = RuntimeConfigure();

  // Whether a keys.
  print(config.contains('app.debug')); // false

  // Sets a value by keys.
  config.set('app.debug', 'odroe:rc');
  print(config.contains('app.debug')); // true

  // Reads a keys.
  print(config('app.debug')); // 'odroe:rc'

  // Reads a collect
  print(config('app')); // {"debug": "odroe:rc"}

  // Update a keys
  config.update<String>('app.debug', (value) => "new value");
  print(config('app.debug')); // 'new value'
}
