# RC

RC is a configuration collection manager that uses `.` (dot) to set and read collection contents. And it is designed with loaders to load collections from various locations such as environment variables.

RC's name uses the acronym of `Runtime Configure`/`Real Collection`. You can use it as a collection container, and you can also use it as a configuration manager with a loader.

> What is a collection? Collection is a concept, usually Map/List/Set/Iterable are all collections.

## Installation

Use command line:

```bash
dart pub add rc
```

Or update your `pubspec.yaml` file:

```yaml
dependencies:
rc: latest
```

## Quick Start

```dart
import 'package:rc/rc.dart';

final config = RC(init: {
    'app': {
        debug: true,
    }
});

// A more concise approach 👇
// final config = RC(init: {'app.debug': true});

print(config('app.debug')); // true
```

Parameters:

| Name | Type | Notes |
|----|----|----|
| `init`| `Map<String, dynamic>?` | Initial collection data |
| `loaders`| `Set<Loader>?` | Loader used |
| `shouldWarn`| `bool` | Whether to allow warning information, default `true` |

### Get data or collection

To get data, we use the `call` method. Usually you can ignore it. You can use the created RC instance in a similar way to function call:

```dart
final value = config('app.debug');
```

It also has a type parameter `T`, which can tell the getter what data type you expect:

```dart
final debug = config<bool>('app.debug');
```

> **Note**: If the `app.debug` data type is not `bool`, it will return null. If `shouldWarn` is configured as `true`, a warning message will be printed in the console.

In addition to getting specific values, you can also get collection values ​​with `Map<String, dynamic>` type:

```dart
final app = config('app'); // {debug: true}
```

### Set a value or collection

Setting a value usually uses the `set` method, which can update a specific value or set a new collection:

```dart
// Sets a value
config.set('app.debug', 1);

// Sets a collection
config.set('user.profile', {
    'id': 1,
    'name': 'Seven',
});
```

Collection values ​​also support `.` connected collections, or a mixture of Map/Set/List/Iterable and `.` collections:

```dart
config.set('app.user', {
    id: 1,
    'emails.0': {id: 1, validated: true},
    'prifile': {
        'id': 1,
        'posts': [
            {id: 1, title: 'First post'},
            {id: 2, title: 'Post 2'},
        ],
    },
});
```

In short, you can combine collection types in any way you want.

### Update a value or collection

Updating a value or collection is usually a syntactic sugar for the combination of `call` and `set`, which allows you to get the previous data for processing before updating the value:

```dart
config.update<bool>('app.debug', (prev) {
if (prev == true) return prev;
    return false;
});
```

### Delete a value or collection

To delete a value or collection, use the `delete` method:

```dart
// Delete a value
config.delete('app.debug');

// Delete colection
config.delete('app');
```

### Whether contains

To determine whether a value or collection exists, you should use the `contains` method:

```dart
config.contains('app');
config.contains('app.debug');
```

## Loaders

Loaders are used to load collections from other places into RC, such as `dart --define` or environment variables.

There are two ways to configure loaders. The first is to set `loaders` when creating `RC`. You can also use `use` to configure loaders after creating an `RC` instance:

```dart
config.use(const DefineLoader());
```

Built-in loaders:

| Loader | Desc |
|----|----|
| `DefineLoader` | KV environment variables configured using `--define` in the Dart/Flutter command line |
| `EnvironmentLoader` | System environment variable loader, usually loads `Platform.environment` content. On platforms that do not support `dart:io`, no data will be loaded. Because there are no environment variables on platforms that do not support `dart:io`. |
| `DotenvLoader` | Load environment variable files into collections, and load `.env` files by default. `.env` is a commonly used KV format configuration file. You can also configure the search directory, or other KV configuration files in compatible formats. |
