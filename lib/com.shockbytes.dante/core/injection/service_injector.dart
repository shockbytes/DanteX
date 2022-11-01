class ServiceInjector {
  ServiceInjector._();

  static setup() async {
    await _setupLocalStorageService();
    await _setupAppSettings();
  }

  static Future _setupLocalStorageService() async {
//     await Get.putAsync<LocalStorageService>(
//       () {
//         return SharedPreferences.getInstance().then((sp) => SharedPreferencesLocalStorageService(sp));
//       },
//       permanent: true,
//     );
  }

  static _setupAppSettings() async {
//     await Get.putAsync<AppSettings>(() {
//       return SharedPreferences.getInstance().then((sp) => SharedPreferencesAppSettings(sp));
//     });
  }
}
