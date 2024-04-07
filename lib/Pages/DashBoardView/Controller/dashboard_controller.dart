import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController{

  int bottomIndex = 0;
  PageController pageController = PageController();

  //
  changePage(int index){

    pageController.jumpToPage(
        index);
    bottomIndex = index;
    update(["bottomBar"]);
  }

}