import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/bookmark/bindings/bookmark_binding.dart';
import 'package:getx_pattern/app/modules/bookmark/views/bookmark_view.dart';
import 'package:getx_pattern/app/modules/channels/bindings/top_channel_binding.dart';
import 'package:getx_pattern/app/modules/channels/views/top_channel_view.dart';
import 'package:getx_pattern/app/modules/login/bindings/login_binding.dart';
import 'package:getx_pattern/app/modules/login/views/login_view.dart';
import 'package:getx_pattern/app/modules/mainscreen.dart';
import 'package:getx_pattern/app/modules/search/bindings/searchnews_binding.dart';
import 'package:getx_pattern/app/modules/search/views/searchnews_view.dart';
import 'package:getx_pattern/app/modules/splash_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: _Paths.SEARCH_NEWS,
      page: () => SearchNewsView(),
      binding: SearchNewsBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: _Paths.TOPCHANNEL,
      page: () => TopNewsChannel(),
      binding: TopChannelBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: _Paths.BOOKMARK,
      page: () => BookmarkView(),
      binding: BookmarkBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreeen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: _Paths.MAINSCREEN,
      page: () => MainScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
    ),
  ];

}
