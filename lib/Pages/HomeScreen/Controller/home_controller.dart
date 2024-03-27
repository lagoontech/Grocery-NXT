import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  ScrollController sc = ScrollController(initialScrollOffset: 300);

  @override
  void onInit() {
    super.onInit();
    sc.addListener(() {
      update();
    });
  }

}