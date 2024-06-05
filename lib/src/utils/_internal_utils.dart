import '../constants.dart';

extension StringIterableUtils on Iterable<String> {
  Iterable<String> withoutEmptyChildren() => where((e) => e.isNotEmpty);
}

void warn(String message) => print('⚠️ [odroe:rc] $message');

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

  return switch (T) {
    String => value.toString() as T,
    _ => null,
  };
}
