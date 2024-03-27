import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/OnboardingScreen/onboarding_screen.dart';

class SplashController extends GetxController{

  //
  checkToken(){

    Future.delayed(const Duration(milliseconds: 3000),(){
      Get.to(()=> OnboardingScreen());
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkToken();
  }

}