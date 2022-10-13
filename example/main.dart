import 'package:rc/rc.dart';

final Environment environment = Environment();

void main() {
  environment['foo'] = 'bar';

  print(environment['foo']);
}
