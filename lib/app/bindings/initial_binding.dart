import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';
import '../../controllers/preview_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeController(Get.find()), fenix: true);
    Get.put(PreviewController(), permanent: true);
  }
}
