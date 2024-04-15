import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Model/order_details_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;

class OrderDetailsController extends GetxController{

  bool isLoading = false;
  int ?orderId;
  OrderDetailsModel ?orderDetails;

  //
  getOrderDetails() async {

    isLoading = true;
    update();
    try{
      var result = await HttpService.getRequest("user/order-detail/$orderId");
      if(result is http.Response){
        if(result.statusCode == 200){
          orderDetails = orderDetailsModelFromJson(result.body);
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    isLoading = false;
    update();
  }

}