import 'package:dantex/src/core/injection/api_injector.dart';
import 'package:dantex/src/core/injection/bloc_injector.dart';
import 'package:dantex/src/core/injection/repository_injector.dart';
import 'package:dantex/src/core/injection/service_injector.dart';
import 'package:get/get.dart';

import 'blocking_components_injector.dart';

/// Nice little wrapper for Dependency Injection code.
/// Allows to switch the underlying dependency injection library, if needed.
class DependencyInjector {
  DependencyInjector._();

  static T get<T extends Object>() {
    return Get.find<T>();
  }

  static void put<T extends Object>(
    T dependency, {
    bool permanent = false,
  }) {
    Get.put(dependency);
  }

  static Future<void> initializeCriticalComponents() async {
    await BlockingComponentsInjector.setup();
  }

  static Future<void> setupDependencyInjection() async {
    ApiInjector.setup();
    await ServiceInjector.setup();
    RepositoryInjector.setup();
    BlocInjector.setup();
  }
}
