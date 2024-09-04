import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Models/order_success_response.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../Services/http_services.dart';
import '../../../Utils/shared_pref_utils.dart';
import '../../DashBoardView/Controller/dashboard_controller.dart';
import '../../OrdersView/Controller/order_controller.dart';
import '../payment_failed.dart';
import '../payment_success.dart';

class PaymentFailedController extends GetxController{


  int ?amount;
  int ?orderId;
  Razorpay razorpay               = Razorpay();
  bool confirmingPayment          = false;
  CartController cartController   = Get.find<CartController>();
  OrderController orderController = Get.find<OrderController>();
  OrderSuccessResponse ?successResponse;
  String ?transactionId;

  //
  retryPayment(){

    try{
      Future.delayed(const Duration(milliseconds: 10),(){
        var options = {
          'key': 'rzp_live_RKDSnxuUFaUL7h',
          'amount': 100,//totalAmount*100,
          'reference_id': orderId.toString(),
          'name': '',
          'description': '',
          'prefill': {
            'contact': '8888888888',
            'email': 'test@razorpay.com'
          }
        };
        razorpay!.open(options);
        cartController.loadProducts();
        orderController.getPendingOrders();
      });
    }catch(e){

    }
  }

  //
  updatePaymentStatus()async{

    confirmingPayment = true;
    update();
    successResponse!.type = "success";
    successResponse!.transactionId = transactionId;
    try{
      var result = await HttpService.postRequest(
          "update-payment",
          successResponse!.toJson(),
          insertHeader: true
      );
      if(result is http.Response){
        if(result.statusCode==200){
          confirmingPayment = false;
          update();
          SharedPrefUtils().clearCart().then((value) {
            Get.back();
            Get.to(()=> PaymentSuccess());
          });
        }
      }
    }catch(e){
      confirmingPayment = false;
    }
    confirmingPayment = false;
    update();
  }

  //
  updatePaymentFailed()async{

    confirmingPayment = true;
    update();
    successResponse!.type = "failure";
    successResponse!.transactionId = "";
    try{
      var result = await HttpService.postRequest(
          "update-payment",
          successResponse!.toJson()..["success"] = "rejected"..["status"] = "cancelled",
          insertHeader: true
      );
      if(result is http.Response){
        if(result.statusCode==200){
          confirmingPayment = false;
          update();
        }
      }
    }catch(e){
      print(e);
      confirmingPayment = false;
    }
    confirmingPayment = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (v){
      transactionId = v.paymentId;
      updatePaymentStatus();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,(v){
      ToastUtil().showToast(message: "Payment failed");
    });
  }

}
