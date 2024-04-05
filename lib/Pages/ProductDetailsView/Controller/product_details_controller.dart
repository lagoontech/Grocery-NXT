import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Model/product_details_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../../AllProductsView/Model/products_list_model.dart';

class ProductDetailsController extends GetxController with GetTickerProviderStateMixin{

  late Animation animation;
  late AnimationController animationController;
  ProductDetailsModel ?productDetails;
  ProductColor ?selectedVariant;
  bool isLoading = true;
  int ?productId;
  String selectedImage = "";
  List<AdditionalInfoStore> additionalInfos = [];
  Product ?product;
  int ?quantity = 1;

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
          productDetails!.additionalInfoStore!.keys.forEach((element) {
            additionalInfos.add(
                productDetails!.additionalInfoStore![element]
            );
          });
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
  changeVariant(){

    int index = productDetails!.productSizes!.indexOf(selectedVariant!);
    if(index==0){
      productDetails!.product!.salePrice = additionalInfos[index].additionalPrice;
      product!.discountPrice = int.parse(additionalInfos[index].additionalPrice.ceil().toString());
      product!.productColor  = null;
      product!.variantInfo   = null;
      return;
    }
    productDetails!.product!.salePrice = additionalInfos[index].additionalPrice;
    product!.discountPrice = int.parse(additionalInfos[index].additionalPrice.ceil().toString());
    product!.productColor  = productDetails!.productSizes![index];
    product!.variantInfo   = additionalInfos[index];
    update();
  }

  //
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