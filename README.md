Dart environment variables for runtime configuration, `Platform.environment` wrapper.

## Why need this package?

`Platform.environment` is a `Map<String, String>` that contains the environment variables of the current process. It is a read-only map. It is not possible to change the environment variables of the current process.

This package provides a `Environment` class that can be used to read and write environment variables. It is a wrapper of `Platform.environment`.

> **NOTE**: Environment changed via wrapper will not be reflected in `Platform.environment`.

## Getting Started

The recommended approach is to create a shared file that contains only the `environment` final variables.

```dart
// environment.dart
import 'package:rc/rc.dart';

final environment = Environment();
```

Then, import the `environment.dart` file in your code.

```dart
import 'environment.dart';

void main() {
  print(environment['HOME']);
}
```

The `Environment` class factory accepts a `Map<String, String>` as argument. This map will be used as the initial environment variables.

```dart
import 'package:rc/rc.dart';

final environment = Environment(
  environment: {
    'HOME': '/home/user',
  },
);
```

Include `Platform.environment` in the initial environment variables.

```dart
import 'package:rc/rc.dart';

final environment = Environment(
  includePlatformEnvironment: true,
);
```

> **NOTE**: The `includePlatformEnvironment` argument is `true` by **default**.
>
> The `Environment` class implements `Map<String, String>`.
