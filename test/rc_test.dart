import 'package:rc/rc.dart';
import 'package:test/test.dart';

void main() {
  test('Environment is a Map<String, String>', () {
    final environment = Environment();
    expect(environment, isA<Map<String, String>>());
  });

  test('Include platform environment', () {
    final environment = Environment(includePlatformEnvironment: false);
    expect(environment, isEmpty);

    final platformEnvironment = Environment(includePlatformEnvironment: true);
    expect(environment, isNot(platformEnvironment));
  });

  test('Override environment', () {
    final environment = Environment();
    environment['HOME'] = '/home/user';
    environment['PATH'] = '/usr/bin:/usr/local/bin';

    expect(environment['HOME'], equals('/home/user'));
    expect(environment['PATH'], equals('/usr/bin:/usr/local/bin'));
  });

  test('Case insensitive', () {
    final environment = Environment();
    environment['HOME'] = '/home/user';
    environment['PATH'] = '/usr/bin:/usr/local/bin';

    final ignoreCaseEnvironment = environment.toIgnoreCase();
    expect(ignoreCaseEnvironment['HOME'], equals('/home/user'));
    expect(ignoreCaseEnvironment['PATH'], equals('/usr/bin:/usr/local/bin'));
    expect(ignoreCaseEnvironment['home'], equals('/home/user'));
    expect(ignoreCaseEnvironment['path'], equals('/usr/bin:/usr/local/bin'));
  });

  test('Case sensitive', () {
    final environment = Environment();
    environment['HOME'] = '/home/user';
    environment['PATH'] = '/usr/bin:/usr/local/bin';

    final caseSensitiveEnvironment = environment.toCaseSensitive();
    expect(caseSensitiveEnvironment['HOME'], equals('/home/user'));
    expect(caseSensitiveEnvironment['PATH'], equals('/usr/bin:/usr/local/bin'));
    expect(caseSensitiveEnvironment['home'], isNull);
    expect(caseSensitiveEnvironment['path'], isNull);
  });
}
