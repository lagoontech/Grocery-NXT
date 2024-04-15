import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/LoginScreen/Controller/login_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}