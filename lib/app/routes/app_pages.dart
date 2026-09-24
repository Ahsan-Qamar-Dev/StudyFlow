import 'package:get/get.dart';

import '../../views/home/home_shell.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomeShell()),
  ];
}
