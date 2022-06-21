import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/app/modules/channels/controllers/top_channel_controller.dart';
import 'package:getx_pattern/app/modules/home/controllers/home_controller.dart';
import 'package:getx_pattern/app/modules/login/controllers/login_controller.dart';
import 'package:getx_pattern/app/modules/search/controllers/searchnews_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<TopChannelController>(
      () => TopChannelController(),
    );

    Get.lazyPut<SearchNewsController>(
      () => SearchNewsController(),
    );

    Get.lazyPut<LoginController>(
          () => LoginController(),fenix: true
    );
    //  Get.put<TopChannelController>(TopChannelController());
  }
}
