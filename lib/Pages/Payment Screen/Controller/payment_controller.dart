import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController{

  bool loadingPaymentOptions = false;

  //
  loadPaymentOptions()async{

    loadingPaymentOptions = true;
    update();
    try{
      var headers = {'x-api-key': "rzp_test_SXk7LZqsBPpAkj"};
      var result  = await HttpService.getRequest("payment-gateway-list");
      if(result is http.Response){
        if(result.statusCode==200){
          if (kDebugMode) {
            print(result.body);
          }
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