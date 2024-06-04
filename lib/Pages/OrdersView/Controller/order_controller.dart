import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Model/order_list_model.dart';
import '../Model/order_pending_list_model.dart' as pendingModel;

class OrderController extends GetxController with GetTickerProviderStateMixin{

  bool loadingOrders = false;
  List<Order> orders = [];
  List<pendingModel.SubordersDatum> pendingOrders   = [];
  List<SubordersDatum> completedOrders = [];
  TabController ?tabController;
  RefreshController refreshController = RefreshController();
  int pendingOrdersPage = 1;
  int completedOrdersPage = 1;

  //
  getOrders({bool isLoading = false}) async {

    if(!isLoading){
      loadingOrders = true;
    }else{
      completedOrdersPage++;
    }
    update();
    try{
      var result = await HttpService.getRequest("user/order-list?page=${completedOrdersPage}");
      if(result is http.Response){
        if(result.statusCode==200){
          if(isLoading){
            completedOrders.addAll(orderListModelFromJson(result.body).suborders!.data!);
          }else {
            completedOrders = orderListModelFromJson(result.body).suborders!.data!;
          }
          print("completed orders -->${completedOrders.length}");
        }
      }
    }catch(e){
      print("Get orders error-->$e");
      if (kDebugMode) {
        print(e);
      }
    }
    if(isLoading){
      refreshController.loadComplete();
    }
    loadingOrders = false;
    update();
  }

  //
  getPendingOrders({bool isLoading = false}) async {

    if(!isLoading){
      loadingOrders = true;
    }else{
      pendingOrdersPage++;
    }
    update();
    try{
      var result = await HttpService.getRequest("user/orderpending-list?page=${pendingOrdersPage}");
      if(result is http.Response){
        if(result.statusCode==200){
          if(isLoading){
            pendingOrders.addAll(pendingModel.orderPendingListModelFromJson(result.body).suborders!.data!);
          }
          else {
            pendingOrders = pendingModel.orderPendingListModelFromJson(result.body).suborders!.data!;
          }
          print("pending orders -->${pendingOrders.length}");
        }
      }
    }catch(e){
      print(e);
    }
    if(isLoading){
      refreshController.loadComplete();
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