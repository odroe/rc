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

### Human intuition path

Normally it is possible to define paths using the `string` type, like this:

```
path1 = path/to
path2 = /tmp/path/to
```

If the path you set is a relative path, it will intuitively feel that it is relative to the current configuration file.

But the opposite is true. The reality is that these paths are compared to the current running directory when you use them.

The solution to this problem is simple, use the `path` type of the Schema:

```
path1(path) = path/to
```

Of course, values of type path also allow environment variables and other variables:

```
path1(path) = ${HOME}/path/to
currentHomePath(path) = ~
```

Then, you can use the `path` type to get the absolute path of the file:

```dart
final rc = RuntimeConfiguration(
  contents: schema,
  root: Directory.current.path,
);
```

If you use a file or path to create a runtime configuration, the default is compared to the path of the configuration file.
```dart
// path/to/.rc contents:
// path1(path) = test.txt
// path2(path) = ../test.txt

final rc = RuntimeConfiguration.from('path/to/.rc');

print(rc('path1')); // path/to/test.txt
print(rc('path2')); // path/test.txt
```

When using configuration files, this configuration path is more in line with human intuition.

> **Note**: More usage you can find in [.rc](.rc) file.

### Parse runtime configuration from file path

```dart
final rc = RuntimeConfiguration.from('.examplerc');
```

## Example

Example pleass see 👉 [example](https://pub.dev/packages/rc/example)
