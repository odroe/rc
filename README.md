A Dart application runtime configuration.

## Installation

Depend on it.

### With Dart:
```bash
dart pub add rc
```

### With Flutter:
```bash
flutter pub add rc
```

### Import it

Now in your Dart code, you can use:

```dart
import 'package:rc/rc.dart';
```

## Getting Started

Create a configuration schema.

```dart
final schema = 'key = value';
```

Then, you can access the configuration value in your code.

```dart
final rc = RuntimeConfiguration(contents: schema);

print(rc('key')); // value
```

## Configuration Schema

The configuration schema is a string that contains the configuration key-value pairs.

```
key = value
```

### The type of the value has automatic inference

```
value1 = 1
value2 = 1.0
value3 = true # or false
value4 = "string"
```

### The type of the value can be specified

```
value1(int) = 1
value2(double) = 1.0
value3(bool) = true # or false
value4(string) = "string"
```

### Boundary symbols supported by String

```
value1 = The is a string not with boundary symbols.
value2 = "This string uses double quotes as boundary symbols"
value3 = 'This string uses single quotes as boundary symbols'
```

### String allow insertion of variables

```
value1 = "This is a string with a variable: ${value2}"
value2 = "This is a variable"
```

### String support for inserting environment variables

```
value = "This is a string with an environment variable: ${HOME}"
```

> **Note**: More usage you can find in [.rc](.rc) file.

## Helper method with filesystem

These methods are exposed in `package:rc/io.dart`

### Parse runtime configuration from file

```dart
import 'package:rc/io.dart';

final file = File('path/to/.rc');
final rc = createRuntimeConfigurationFromFile(file);
```

### Parse runtime configuration from file path

```dart
import 'package:rc/io.dart';

// Default file name is .rc
final rc1 = createRuntimeConfigurationFromPath();

// Custon file name
final rc2 = createRuntimeConfigurationFromPath(
  path: 'path/to/.rc',
);
```

## Example

Example pleass see 👉 [example](https://pub.dev/packages/rc/example)
