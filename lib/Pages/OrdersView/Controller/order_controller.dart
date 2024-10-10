import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/OrdersView/Model/orders_on_the_way_model.dart';
import 'package:grocery_nxt/Pages/OrdersView/Model/picked_orders_model.dart';
import 'package:grocery_nxt/Pages/OrdersView/Model/processed_orders_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Model/order_list_model.dart';
import '../Model/order_pending_list_model.dart' as pendingModel;

class OrderController extends GetxController with GetTickerProviderStateMixin{

  bool loadingOrders                                = false;
  List<Order> orders                                = [];
  List<pendingModel.SubordersDatum> pendingOrders   = [];
  List<SubordersDatum> completedOrders              = [];
  List<ProcessedDatum> processedOrders              = [];
  List<PickedOrderDatum> pickedOrders               = [];
  List<OnthewayDatum> onthewayOrders                = [];
  TabController ?tabController;
  RefreshController refreshController               = RefreshController();
  int pendingOrdersPage                             = 1;
  int completedOrdersPage                           = 1;
  int processedOrdersPage                           = 1;
  int currentTab                                    = 0;

  //
  getOrders({bool isLoading = false}) async {

    if(!isLoading){
      loadingOrders = true;
      completedOrdersPage = 1;
    }else{
      completedOrdersPage++;
    }
    update();
    try {
      var result = await HttpService.getRequest(
          "user/order-list?page=${completedOrdersPage}");
      if (result is http.Response) {
        if (result.statusCode == 200) {
          if (isLoading) {
            completedOrders.addAll(
                orderListModelFromJson(result.body).suborders!.data!);
          } else {
            completedOrders =
            orderListModelFromJson(result.body).suborders!.data!;
          }
        }
      }
      if (isLoading) {
        refreshController.loadComplete();
      }
    }catch (e) {
      loadingOrders = false;
      update();
    }
    loadingOrders = false;
    update();
  }

  //
  getPendingOrders({bool isLoading = false}) async {

    if(!isLoading){
      loadingOrders = true;
      pendingOrdersPage = 1;
    }else{
      pendingOrdersPage++;
    }
    update();
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
    if(isLoading){
      refreshController.loadComplete();
    }
    loadingOrders = false;
    update();

  }

  //
  getProcessedOrders({bool isLoading = false}) async{

    if(!isLoading){
      loadingOrders = true;
      processedOrdersPage = 1;
    }else{
      processedOrdersPage++;
    }
    update();
    try{
      var result = await HttpService.getRequest("user/orderprocessing-list?page=${processedOrdersPage}");
      if(result is http.Response){
        if(result.statusCode==200){
          if(isLoading){
            processedOrders.addAll(processingOrdersModelFromJson(result.body).processingOrders!.data!);
          }else{
            processedOrders = processingOrdersModelFromJson(result.body).processingOrders!.data!;
          }
        }
      }
    }catch(e){
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
  getPickedByCourierOrders() async{

    loadingOrders = true;
    update();
    try{
      var result = await HttpService.getRequest("user/orderpickup-list");
      if(result is http.Response){
        if(result.statusCode==200){
          pickedOrders = pickedOrdersModelFromJson(result.body).suborders!.data!;
        }
      }
    }catch(e){
      print(e);
    }
    loadingOrders = false;
    update();
  }

  //
  getOnTheWayOrders() async{

    loadingOrders = true;
    update();
    try{
      var result = await HttpService.getRequest("user/orderontheway-list");
      if(result is http.Response){
        if(result.statusCode==200){
          onthewayOrders = onthewayOrdersModelFromJson(result.body).suborders!.data!;
        }
      }
    }catch(e){
      print(e);
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