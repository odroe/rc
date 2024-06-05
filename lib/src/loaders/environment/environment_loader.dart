import '../../loader.dart';
import '../define/define_loader.dart';
import '_system_environment.dart'
    if (dart.library.io) '_system_environment.io.dart';

///
class EnvironmentLoader extends Loader {
  const EnvironmentLoader();

  @override
  get dependencies => const {DefineLoader()};

  @override
  load({required bool shouldWarn}) => readSystemEnvironment(shouldWarn);
}
