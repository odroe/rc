extension StringIterableUtils on Iterable<String> {
  Iterable<String> withoutEmptyChildren() => where((e) => e.isNotEmpty);
}

void warn(String message) => print('⚠️ [odroe:rc] $message');
