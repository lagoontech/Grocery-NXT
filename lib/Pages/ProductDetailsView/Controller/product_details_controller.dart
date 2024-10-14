import 'dart:developer';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/ProductDetailsView/Model/product_details_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;
import '../../AllProductsView/Model/products_list_model.dart';

class ProductDetailsController extends GetxController
    with GetTickerProviderStateMixin {

  late Animation animation;
  late AnimationController animationController;
  CartController cc    = Get.find<CartController>();
  ProductDetailsModel? productDetails;
  ProductColor? selectedVariant;
  ProductColor? selectedType;
  bool isLoading       = true;
  int? productId;
  String selectedImage = "";
  List<AdditionalInfoStore> additionalInfos = [];
  Product? product;
  int? quantity  = 1;
  String preBook = "";
  bool booking   = false;

  //
  getProductDetails() async {

    try {
      var result = await HttpService.getRequest("product/$productId");
      if (result is http.Response) {
        if (kDebugMode) {
          print(result.body);
        }
        if (result.statusCode == 200) {
          productDetails = productDetailsModelFromJson(result.body);
          if(productDetails!.productColors!=null && productDetails!.productColors!.isNotEmpty){
            for (var element in productDetails!.productSizes!) {
              for (var detail in productDetails!.product!.inventoryDetails!) {
                if(detail.size == element.id.toString()){
                  if(element.itemTypes == null){
                    element.itemTypes = [];
                  }
                  element.itemTypes!.add(ProductColor.fromJson(detail.productColor)..additionalPrice = element.additionalPrice);
                }
              }
            }
          }
          selectedImage = productDetails!.product!.image!;
          animationController.forward();
          if (productDetails!.additionalInfoStore != null) {
            for (var element in productDetails!.additionalInfoStore!.keys) {
              additionalInfos
                  .add(productDetails!.additionalInfoStore![element]!);
            }
          }
          checkVariant();
          productDetails!.product!.galleryImages!.add(productDetails!.product!.image!);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    isLoading = false;
    update();

  }

  //
  changeVariant() {

    int index = 0;
    index = productDetails!.productSizes!.indexOf(selectedVariant!);
    if (kDebugMode) {
      print("selected variant index-->$index");
    }
    if(selectedVariant!.itemTypes != null && selectedVariant!.itemTypes!.isNotEmpty && selectedType != null){
      int index = 0;
      for (var element in productDetails!.product!.inventoryDetails!) {
        if(element.size.toString() == selectedVariant!.id.toString()){
          if(element.color == selectedType!.id.toString()){
            productDetails!.product!.salePrice = element.additionalPrice;
            product!.discountPrice             = element.additionalPrice;
            product!.postInventoryId           = element.id.toString();
            product!.itemType                  = selectedType;
          }
        }
      }
    }else{
      productDetails!.product!.salePrice = additionalInfos[index].additionalPrice;
      product!.discountPrice             = int.parse(additionalInfos[index].additionalPrice.ceil().toString());
    }
    product!.productColor    = productDetails!.productSizes![index];
    product!.variantInfo     = additionalInfos[index];
    product!.cartQuantity    = quantity!;
    product!.stockCount      = additionalInfos[index].stockCount;
    product!.postInventoryId =
        productDetails!.product!.inventoryDetails!.firstWhere((element) =>
        element.size == product!.productColor!.id.toString()).id.toString();
    update();

  }

  //
  checkVariant() {
    bool regularProductInCart = cc.products
        .firstWhere(
            (element) =>
        element.prdId == product!.prdId &&
            element.variantInfo == null,
        orElse: () => Product())
        .prdId !=
        null;
    if (regularProductInCart) {
      print("regularProductInCart");
      quantity = cc.products
          .firstWhere((element) =>
      element.prdId == product!.prdId && element.variantInfo == null)
          .cartQuantity;
      selectedVariant = productDetails!.productSizes!.first..itemTypes=[];
      changeVariant();
      return;
    }

    bool variantInCart = cc.products
        .firstWhere(
            (element) =>
        element.prdId == product!.prdId &&
            element.variantInfo != null,
        orElse: () => Product())
        .prdId !=
        null;
    if (variantInCart) {
      int index = cc.products.indexWhere((element) =>
      element.prdId == product!.prdId && element.variantInfo != null);
      selectedVariant = productDetails!.productSizes!.firstWhere((element) {
        return element.id == cc.products[index].productColor!.id;
      });
      quantity = cc.products
          .firstWhere((element) =>
      element.prdId == product!.prdId && element.variantInfo != null)
          .cartQuantity;
      changeVariant();
      update();
      return;
    }
    if(productDetails!.productSizes!.isNotEmpty){
      selectedVariant = productDetails!.productSizes![0];
      changeVariant();
    }
  }

  //
  preBookAPI() async {

    booking = true;
    update();
    try{
      var result = await HttpService.postRequest("addToprebookAjax",{
        "pid": product!.prdId,
        "preqty": quantity
      },insertHeader: true);
      if(result is http.Response){
        if(result.statusCode==200){
          ToastUtil().showToast(message: "Successfully booked");
        }
      }
    }catch(e){
      print(e);
    }
    booking = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut, // Apply curve here
      ),
    );
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
