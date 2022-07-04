import 'package:get/get.dart';
import '../controllers/searchnews_controller.dart';

class SearchNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchNewsController>(
      () => SearchNewsController(),
    );
  }
}
