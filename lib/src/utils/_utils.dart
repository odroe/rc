import '../constants.dart';
import '_logger.dart';

extension StringIterableUtils on Iterable<String> {
  Iterable<String> withoutEmptyChildren() => where((e) => e.isNotEmpty);
}

bool shouldWarn(Map<String, dynamic> storage) {
  return switch (storage[shouldWarnKeys]) {
    bool value => value,
    _ => true,
  };
}

T? warnTypeCast<T>(String keys, value, bool shouldWarn) {
  try {
    if (value is T?) return value;
    return value as T?;
  } catch (_) {
    if (shouldWarn) {
      warn('Found \'$keys\' with data type $T, expected ${value.runtimeType}');
    }
  }

  if (T == String) {
    return value.toString() as T;
  }

  return null;
}
