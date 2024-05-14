import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/DashBoardView/dashboard_view.dart';
import 'package:grocery_nxt/Pages/OnboardingScreen/onboarding_screen.dart';
import 'package:grocery_nxt/Services/network_util.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';

class SplashController extends GetxController{

  bool networkError = false;
  StreamSubscription<List<ConnectivityResult>> ?connectionStream;

  //
  checkToken(){

      Future.delayed(const Duration(milliseconds: 3000),() async {
        if(await SharedPrefUtils().isLoggedIn()){
          Get.offAll(()=> OnboardingScreen());
        }else{
          Get.offAll(()=> DashboardView());
        }
      });
  }

  //
  listenForConnectionChanges(){

    Connectivity connectivity = Connectivity();
    connectionStream = connectivity.onConnectivityChanged.listen((event) {
      log(event.toString());
      if(event[0]!=ConnectivityResult.none){
        networkError = false;
        update();
        checkToken();
      }else{
        networkError = true;
        update();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkToken();
   // listenForConnectionChanges();
  }

}