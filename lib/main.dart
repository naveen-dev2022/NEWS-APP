import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/app/modules/home/controllers/home_controller.dart';
import 'package:getx_pattern/core/values/languages/local_strings.dart';
import 'package:getx_pattern/core/values/theme/themes_service.dart';
import 'package:sizer/sizer.dart';
import 'app/root_binding/root_binding.dart';
import 'app/routes/app_pages.dart';
import 'core/values/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  runApp(Sizer(builder: (context, orientation, deviceType) {
    Get.put(BookmarkController(), permanent: true);
    return GetMaterialApp(
      title: "Application",
      supportedLocales: const [Locale('en', 'US')], //, Locale('pt', 'BR')],
      translations: LocalString(),
      locale: const Locale('en','US'),
      initialRoute: AppPages.INITIAL,
      initialBinding: RootBinding(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: Themes().LightTheme,
      darkTheme: Themes().DarkTheme,
      themeMode: ThemeService().getThemeMode(),
    );
  }));

}

