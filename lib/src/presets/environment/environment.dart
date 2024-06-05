import '../../preset.dart';
import '../dart_define/dart_define.dart';
import '_system_environment.dart'
    if (dart.library.io) '_system_environment.io.dart';

class Environment extends Preset {
  const Environment();

  @override
  get dependencies => const {DartDefine()};

  @override
  load() => systemEnvironment;
}
