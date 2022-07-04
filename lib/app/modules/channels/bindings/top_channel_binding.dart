import 'package:get/get.dart';
import '../controllers/top_channel_controller.dart';

class TopChannelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopChannelController>(
      () => TopChannelController(),
    );
  }
}
