import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../Model/order_list_model.dart';

class OrderController extends GetxController with GetTickerProviderStateMixin{

  bool loadingOrders = false;
  List<Order> orders = [];
  List<Order> pendingOrders   = [];
  List<Order> completedOrders = [];
  TabController ?tabController;

  //
  getOrders() async {

    loadingOrders = true;
    update();
    try{
      var result = await HttpService.getRequest("user/order-list");
      if(result is http.Response){
        if(result.statusCode==200){
          orders = orderListModelFromJson(result.body).orders!;
          pendingOrders = orders.where((element) => element.orderStatus=="pending").toList();
          completedOrders = orders.where((element) => element.orderStatus=="complete").toList();
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loadingOrders = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      update();
    });
    getOrders();
  }

}