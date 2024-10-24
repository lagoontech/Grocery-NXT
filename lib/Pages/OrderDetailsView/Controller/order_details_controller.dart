import 'package:double_back_to_close/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Model/order_details_model.dart';
import 'package:grocery_nxt/Pages/ProfileView/Controller/profile_controller.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Payment Screen/Models/order_success_response.dart';
import '../../Payment Screen/payment_failed.dart';

class OrderDetailsController extends GetxController{

  bool isLoading = false;
  bool isRating  = false;
  int ?orderId;
  OrderDetailsModel ?orderDetails;
  var razorpay = Razorpay();
  String ?transactionId;
  OrderSuccessResponse? successResponse = OrderSuccessResponse();
  bool statusChanged   = false;
  bool updatingPayment = false;
  ProfileController profileController = Get.find<ProfileController>();
  DateTime ?expectedDeliveryDate;

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
  rateProduct(Product product,{String ratingMessage = "",int ?rating}) async {

    isRating = true;
    update();
    try{
      var result = await HttpService.postRequest("product-review",{
          "id" : product.id,
          "user_id" : profileController.profile!.userDetails!.id,
          "rating" : rating,
          "comment" : ratingMessage
      },insertHeader: true);
      if(result is http.Response){
        if(result.statusCode == 200){
          ToastUtil().showToast(message: "Product rated successfully");
          Get.back();
        }
      }
    }catch(e){
      print("rating error-->$e");
    }
    isRating = false;
    update();
    
  }

  //
  processPayment(){

    double amount = double.parse(orderDetails!.order![0].totalAmount!) + double.parse(orderDetails!.order![0].shippingCost!);
    var options = {
      'key': 'rzp_live_RKDSnxuUFaUL7h',
      'amount': int.parse(amount.toStringAsFixed(0))*100,//totalAmount*100,
      'reference_id': orderId.toString(),
      'name': '',
      'description': '',
      'prefill': {
        'contact': profileController.profile!.userDetails!.phone!,
        'email': profileController.profile!.userDetails!.email!
      }
    };
    razorpay.open(options);

  }

  //
  updatePaymentStatus()async{

    updatingPayment = true;
    update();
    successResponse!.type          = "success";
    successResponse!.transactionId = transactionId;
    successResponse!.orderId       = orderId;
    successResponse!.invoiceNumber = orderDetails!.order![0].order!.invoiceNumber;
    successResponse!.secreteKey    = orderDetails!.secretKey;
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
    updatingPayment = false;
    update();
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
      //Get.to(()=>const PaymentFailed());
      ToastUtil().showToast(message: "Payment Failed");
    });
  }

}