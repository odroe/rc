import '../../utils/_logger.dart';

Map<String, String> readSystemEnvironment(bool shouldWarn) {
  if (shouldWarn) {
    warn(
        'The current environment does not support environment, will return empty.');
  }

  return const {};
}
