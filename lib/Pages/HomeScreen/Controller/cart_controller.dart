import 'dart:convert';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import '../../AllProductsView/Model/products_list_model.dart';

class CartController extends GetxController{

  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  List<Product> products = [];
  double totalCost = 0.0;
  int totalProducts = 0;

  //
  addToCartFromDetailsPage({Product ?product}){


  }

  //
  addToCart({
    Product ?product,
    bool isSub = false,
    bool showToast = true,
    bool isVariant = false}){

    bool hasProduct = products.firstWhere((element) => element.prdId==product!.prdId,orElse: ()=> Product(prdId: null)).prdId!=null;
    if(isVariant){
      int index = products.indexWhere((element) =>
      element.prdId==product!.prdId && element.productColor!.id==product.productColor!.id);
      if(isSub){
        products[index].cartQuantity = products[index].cartQuantity-1;
        if(products[index].cartQuantity==0){
          products.removeAt(index);
        }
      }else{
        if(index!=-1){
          products[index].cartQuantity = products[index].cartQuantity+1;
        }else{
          products.add(product!..cartQuantity=1);
        }
      }
      SharedPrefUtils.pref!.setStringList(
          "products",products.map((e){return jsonEncode(e.toJson());}).toList());
      calculateTotal();
      calculateTotalProducts();
      update();
      return;
    }

    int index = products.indexWhere((element) => element.prdId==product!.prdId);
    if(isSub){
      if(products.contains(product) || hasProduct){
        products[index].cartQuantity = products[index].cartQuantity-1;
        if(products[index].cartQuantity==0){
          products.removeAt(index);
        }
      }
      update();
      SharedPrefUtils.pref!.setStringList(
          "products",products.map((e){return jsonEncode(e.toJson());}).toList());
      calculateTotal();
      calculateTotalProducts();
      return;
    }
    if(products.contains(product) || hasProduct){
      products[index].cartQuantity = products[index].cartQuantity+1;
    }else{
      products.add(product!..cartQuantity=1);
    }
    SharedPrefUtils.pref!.setStringList(
        "products",
        products.map((e){return jsonEncode(e.toJson());}).toList());
    calculateTotal();
    calculateTotalProducts();
    update();
  }

  //
  bool hasProduct(Product product){
    return products.firstWhere((element) => element.prdId==product.prdId,
        orElse: ()=> Product(prdId: null)).prdId!=null;
  }

  //
  calculateTotal(){
    totalCost = 0.0;
    for (var element in products) {
      totalCost = totalCost + (element.discountPrice!*element.cartQuantity);
    }
  }

  //
  calculateTotalProducts(){
    totalProducts = 0;
    products.forEach((element) {
      totalProducts = totalProducts+element.cartQuantity;
    });
  }

  //
  loadProducts(){

    if(SharedPrefUtils.pref!.containsKey("products")) {
      SharedPrefUtils.pref!.getStringList("products")!.forEach((element) {
      products.add(Product.fromJson(jsonDecode(element)));
    });
    }
    calculateTotalProducts();
    calculateTotal();
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

}