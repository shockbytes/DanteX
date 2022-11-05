import 'package:dantex/com.shockbytes.dante/core/injection/api_injector.dart';
import 'package:dantex/com.shockbytes.dante/core/injection/bloc_injector.dart';
import 'package:dantex/com.shockbytes.dante/core/injection/repository_injector.dart';
import 'package:dantex/com.shockbytes.dante/core/injection/service_injector.dart';
import 'package:get/get.dart';

import 'blocking_components_injector.dart';

class DependencyInjector {
  DependencyInjector._();

  static T get<T extends Object>() {
    return Get.find<T>();
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
