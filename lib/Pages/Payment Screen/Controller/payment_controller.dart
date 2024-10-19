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
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../ProfileView/Controller/profile_controller.dart';

class PaymentController extends GetxController {

  bool loadingPaymentOptions                = false;
  List<PaymentOption> options               = [];
  PaymentOption? selectedOption;
  CartController cartController             = Get.find<CartController>();
  OrderController orderController           = Get.find<OrderController>();
  ChooseAddressController addressController = Get.find<ChooseAddressController>();
  ProfileController profileController       = Get.find<ProfileController>();
  bool isPlacingOrder    = false;
  int ?orderId;
  dynamic totalAmount;
  var razorpay           = Razorpay();
  OrderSuccessResponse ?successResponse;
  String ?transactionId;
  bool confirmingPayment = false;
  bool paid              = false;

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
          if(!addressController.showCOD){
            options.removeWhere((element) => element.name=="cash_on_delivery");
          }
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

    if(selectedOption==null){
      ToastUtil().showToast(message: "Select a payment method");
      return;
    }
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
        'phone': profileController.profile!.userDetails!.phone!,
        'cart_items': jsonEncode(cart_post),
        'selected_payment_gateway': selectedOption!.name!,
        'country_id': "70",
        'state_id': addressController.selectedAddress!.stateId.toString(),
        'zip_code': addressController.selectedAddress!.zipCode!,
        'email': addressController.selectedAddress!.email,
        'shipping_cost': addressController.shippingCharge.toString(),
        'address': addressController.selectedAddress!.address!,
        'agree': 'on',
        'city': addressController.selectedAddress!.city!=null
            ? addressController.selectedAddress!.city!.id.toString()
            : "",
        'coupon': cartController.couponController.text
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
       await response.stream.bytesToString().then((value) async {
         print(value);
         if(response.statusCode==200) {
           orderId     = jsonDecode(value)["order_id"];
           totalAmount = jsonDecode(value)["total_amount"];
           successResponse = OrderSuccessResponse.fromJson(jsonDecode(value));
           if(selectedOption!.name!.contains("razorpay")){
             Future.delayed(const Duration(milliseconds: 10),(){
               var options = {
                 'key': 'rzp_live_RKDSnxuUFaUL7h',
                 'amount': totalAmount * 100,
                 'reference_id': orderId.toString(),
                 'name': '',
                 'description': orderId.toString(),
                 'prefill': {
                   'contact': profileController.profile!.userDetails!.phone!,
                   'email': profileController.profile!.userDetails!.email!,
                 }
               };
               razorpay.open(options);
               cartController.loadProducts();
               orderController.getPendingOrders();
             });
           }
           else {
             SharedPrefUtils().clearCart().then((value) {
             cartController.loadProducts();
             orderController.getPendingOrders();
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
  updatePaymentStatus() async{

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
      if(kDebugMode){
        log(successResponse!.toJson().toString());
      }
      if(result is http.Response){
        log(result.body);
        if(result.statusCode==200){
          confirmingPayment = false;
          update();
          SharedPrefUtils().clearCart().then((value) {
            cartController.loadProducts();
            orderController.getOrders();
            Get.back();
            Get.back();
            Get.back();
            Get.to(()=> PaymentSuccess());
          });
        }else {
          print(result.body);
        }
      }
    } catch(e){
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
          SharedPrefUtils().clearCart().then((value) {
            cartController.loadProducts();
            orderController.getPendingOrders();
            Get.back();
            Get.back();
            Get.back();
            Get.to(()=> PaymentFailed());
          });
        }else {
          SharedPrefUtils().clearCart().then((value) {
            cartController.loadProducts();
            orderController.getPendingOrders();
            Get.back();
            Get.back();
            Get.back();
            Get.to(()=> PaymentFailed(
              successResponse: successResponse,
              orderId: orderId,
              amount: int.parse(totalAmount.toString()),
              subTotal: cartController.subTotal.toInt(),
            ));
          });
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      confirmingPayment = false;
    }
    confirmingPayment = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    loadPaymentOptions();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (v){
      if(kDebugMode){
        print("razorpay trId-->${v.paymentId}");
      }
      transactionId = v.paymentId;
      updatePaymentStatus();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,(v){
      SharedPrefUtils().clearCart().then((value) {
        updatePaymentFailed();
        cartController.loadProducts();
      });
    });
  }

}
