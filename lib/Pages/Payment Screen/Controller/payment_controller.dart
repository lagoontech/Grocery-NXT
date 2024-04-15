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
import 'package:grocery_nxt/Pages/Payment%20Screen/Models/payment_options_model.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/RazorpayPayment/razorpay_payment.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:http/http.dart' as http;

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
    update();
    try {
      var headers = {
        'Authorization':
            'Bearer 204|fP4iyoV8HNi1VmoiYfKomjne9DZnbMJXZuIzdxZr3e541c27',
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiConstants().baseUrl}checkout'));
      request.fields.addAll({
        'full_name': addressController.selectedAddress!.name,
        'note': "",
        'phone': "9080761312",
        'cart_items':
            jsonEncode(cartController.products.map((e) => e.toJson()).toList()),
        'selected_payment_gateway': 'cash',
        'country_id': "70",
        'state_id': addressController.selectedAddress!.stateId.toString(),
        'zip_code': addressController.selectedAddress!.zipCode!,
        'email': addressController.selectedAddress!.email,
        'shipping_cost': jsonEncode("0"),
        'address': addressController.selectedAddress!.address!,
        'agree': 'on',
        'coupon': ''
      });
      request.headers.addAll(headers);
      log(request.fields.toString());
      http.StreamedResponse response = await request.send();

      final resData = await response.stream.bytesToString();
      if (jsonDecode(resData)["success"] == true) {
        print(jsonDecode(resData));
        orderId = jsonDecode(resData)["order_id"];
        totalAmount = jsonDecode(resData)["total_amount"];
        if(selectedOption!.name!.contains("razor")){
          Get.to(()=>RazorpayPayment());
          return;
        }
        SharedPrefUtils().clearCart().then((value) {
          cartController.loadProducts();
          orderController.getOrders();
          Get.back();
          Get.back();
          Get.to(()=>const OrderSuccessScreen());
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    isPlacingOrder = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    loadPaymentOptions();
  }
}
