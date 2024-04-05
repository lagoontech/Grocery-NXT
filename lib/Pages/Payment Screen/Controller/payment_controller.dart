import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Models/payment_options_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController{

  bool loadingPaymentOptions = false;
  List<PaymentOption> options = [];
  PaymentOption ?selectedOption;

  //
  loadPaymentOptions()async{

    loadingPaymentOptions = true;
    update();
    try{
      var result  = await HttpService.getRequest("payment-gateway-list");
      if(result is http.Response){
        if(result.statusCode==200){
          options = paymentOptionsModelFromJson(result.body).paymentOptions!;
        }
        else{
          print(result.body);
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loadingPaymentOptions = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    loadPaymentOptions();
  }

}