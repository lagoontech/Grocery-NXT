import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../Model/order_list_model.dart';
import '../Model/order_pending_list_model.dart' as pendingModel;

class OrderController extends GetxController with GetTickerProviderStateMixin{

  bool loadingOrders = false;
  List<Order> orders = [];
  List<pendingModel.SubordersDatum> pendingOrders   = [];
  List<SubordersDatum> completedOrders = [];
  TabController ?tabController;

  //
  getOrders() async {

    loadingOrders = true;
    update();
    try{
      var result = await HttpService.getRequest("user/order-list");
      if(result is http.Response){
        if(result.statusCode==200){
          completedOrders = orderListModelFromJson(result.body).suborders!.data!;
          print("completed orders -->${completedOrders.length}");
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

  //
  getPendingOrders() async {

    loadingOrders = true;
    update();
    try{
      var result = await HttpService.getRequest("user/orderpending-list");
      if(result is http.Response){
        if(result.statusCode==200){
          pendingOrders = pendingModel.orderPendingListModelFromJson(result.body).suborders!.data!;
          print("pending orders -->${pendingOrders.length}");

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

  //
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      update();
    });
    getOrders();
    getPendingOrders();
  }

}