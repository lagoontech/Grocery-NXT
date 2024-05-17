import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Model/order_details_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Payment Screen/Models/order_success_response.dart';
import '../../Payment Screen/payment_failed.dart';

class OrderDetailsController extends GetxController{

  bool isLoading = false;
  int ?orderId;
  OrderDetailsModel ?orderDetails;
  var razorpay = Razorpay();
  String ?transactionId;
  OrderSuccessResponse? successResponse = OrderSuccessResponse();
  bool statusChanged = false;

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

  //
  processPayment(){

    double amount = double.parse(orderDetails!.order![0].totalAmount!);
    var options = {
      'key': 'rzp_live_RKDSnxuUFaUL7h',
      'amount': 100,//int.parse(amount.toStringAsFixed(0))*100,//totalAmount*100,
      'reference_id': orderId.toString(),
      'name': '',
      'description': '',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      }
    };
    razorpay.open(options);
  }


  //
  updatePaymentStatus()async{

    successResponse!.type = "success";
    successResponse!.transactionId = transactionId;
    successResponse!.orderId = orderId;
    try{
      var result = await HttpService.postRequest(
          "update-payment",
          successResponse!.toJson(),
          insertHeader: true
      );
      if(result is http.Response){
        if(result.statusCode==200){
          getOrderDetails();
          statusChanged = true;
        }
      }
    }catch(e){
      print(e);
    }
  }

  //
  @override
  void onInit() {
    super.onInit();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (v){
      print("razorpay trId-->${v.paymentId}");
      transactionId = v.paymentId;
      updatePaymentStatus();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,(v){
      Get.to(()=>const PaymentFailed());
    });
  }

}