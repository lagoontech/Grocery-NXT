import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';

class DashboardController extends GetxController{

  int bottomIndex = 0;
  PageController pageController = PageController();
  bool signedIn = false;

  //
  changePage(int index){

    pageController.jumpToPage(
        index);
    bottomIndex = index;
    update(["bottomBar"]);
  }

  //
  getLoginStatus() async{

    signedIn = await SharedPrefUtils().isLoggedIn();
  }

  //
  @override
  void onInit() {
    super.onInit();
    getLoginStatus();
  }

}