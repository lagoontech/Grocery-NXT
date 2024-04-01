import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Model/product_details_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;

class ProductDetailsController extends GetxController with GetTickerProviderStateMixin{

  late Animation animation;
  late AnimationController animationController;
  ProductDetailsModel ?productDetails;
  bool isLoading = true;
  int ?productId;
  String selectedImage = "";

  //
  getProductDetails() async {

    try{
      var result = await HttpService.getRequest("product/$productId");
      if(result is http.Response){
        if (kDebugMode) {
          print(result.body);
        }
        if(result.statusCode == 200){
          productDetails = productDetailsModelFromJson(result.body);
          selectedImage = productDetails!.product!.image!;
          animationController.forward();
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

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750));
    animation = Tween<double>(begin: 0,end: 1).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut, // Apply curve here
    ),);
    animation.addListener(() {
      if (kDebugMode) {
        print(animation.value);
      }
      update();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


}