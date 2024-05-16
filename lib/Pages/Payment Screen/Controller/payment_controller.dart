import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Controller/choose_address_controller.dart';
import 'package:grocery_nxt/Pages/DashBoardView/dashboard_view.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/OrderSuccessScreen/order_success_screen.dart';
import 'package:grocery_nxt/Pages/OrdersView/Controller/order_controller.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Models/order_success_response.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Models/payment_options_model.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/RazorpayPayment/razorpay_payment.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/payment_failed.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/payment_success.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

class PaymentController extends GetxController {
  bool loadingPaymentOptions = false;
  List<PaymentOption> options = [];
  PaymentOption? selectedOption;
  CartController cartController = Get.find<CartController>();
  OrderController orderController = Get.find<OrderController>();
  ChooseAddressController addressController = Get.find<ChooseAddressController>();
  bool isPlacingOrder = false;
  int    ?orderId;
  dynamic totalAmount;
  var razorpay = Razorpay();
  OrderSuccessResponse ?successResponse;
  String ?transactionId;

  //
  loadPaymentOptions() async {
    loadingPaymentOptions = true;
    update();
    try {
      var result = await HttpService.getRequest("payment-gateway-list");
      if (result is http.Response) {
        if (result.statusCode == 200) {
          options = paymentOptionsModelFromJson(result.body).paymentOptions!;
          log(options[1].credentials!.secretKey.toString());
        } else {
          print(result.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    loadingPaymentOptions = false;
    update();
  }

  //
  placeOrder() async {

    isPlacingOrder = true;
    Map<String,dynamic> cart_post = {};
    for (var element in cartController.products) {
      var id = const Uuid().v1();
      cart_post[id] = element.toJson()..["row_id"]=id;
    }
    update();
    try {
      var headers = {
        'Authorization': "Bearer ${await SharedPrefUtils().getToken()}",
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiConstants().baseUrl}checkout'));
      request.fields.addAll({
        'full_name': addressController.selectedAddress!.name,
        'note': "",
        'phone': "9080761312",
        'cart_items':
            jsonEncode(cart_post),
        'selected_payment_gateway': selectedOption!.name!,
        'country_id': "70",
        'state_id': addressController.selectedAddress!.stateId.toString(),
        'zip_code': addressController.selectedAddress!.zipCode!,
        'email': addressController.selectedAddress!.email,
        'shipping_cost': addressController.shippingCharge.toString(),//jsonEncode([{"shipping_cost":addressController.shippingCharge}]),
        'address': addressController.selectedAddress!.address!,
        'agree': 'on',
        'coupon': ''
      });
      request.headers.addAll(headers);
      print(request.fields);
      log(request.fields.toString());
      http.StreamedResponse response = await request.send();
       await response.stream.bytesToString().then((value) async {
         if(response.statusCode==200) {
           orderId     = jsonDecode(value)["order_id"];
           totalAmount = jsonDecode(value)["total_amount"];
           successResponse = OrderSuccessResponse.fromJson(jsonDecode(value));
           if(selectedOption!.name!.contains("razorpay")){
             Future.delayed(const Duration(milliseconds: 1000),(){
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
               razorpay.open(options);
             });
           }
           else {
             SharedPrefUtils().clearCart().then((value) {
             cartController.loadProducts();
             orderController.getOrders();
             Get.back();
             Get.back();
             Get.to(()=>const OrderSuccessScreen());
           });
           }
         }
       });
    } catch (e) {
      print(e);
    }
    isPlacingOrder = false;
    update();
  }

  //
  updatePaymentStatus()async{

    successResponse!.type = "success";
    successResponse!.transactionId = transactionId;
    print(successResponse!.toJson());
    try{
      var result = await HttpService.postRequest(
          "update-payment",
          successResponse!.toJson(),
        insertHeader: true
      );
      if(result is http.Response){
        if(result.statusCode==200){
          SharedPrefUtils().clearCart().then((value) {
            cartController.loadProducts();
            orderController.getOrders();
            Get.back();
            Get.back();
            Get.back();
            Get.to(()=>const PaymentSuccess());
          });
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
    loadPaymentOptions();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (v){
      print("razorpay trId-->${v.paymentId}");
      transactionId = v.paymentId;
      updatePaymentStatus();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,(v){
      SharedPrefUtils().clearCart().then((value) {
        cartController.loadProducts();
        orderController.getOrders();
        Get.back();
        Get.back();
        Get.back();
        Get.to(()=>const PaymentSuccess());
      });
      Get.to(()=>const PaymentFailed());
    });
  }

}
