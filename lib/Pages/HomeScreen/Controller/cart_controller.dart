import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../AllProductsView/Model/products_list_model.dart';

class CartController extends GetxController{

  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  List<Product> products = [];
  double totalCost = 0.0;
  int totalProducts = 0;

  //
  addToCart({Product ?product,bool isSub = false,bool showToast = true}){
    
    if(isSub){
      if(products.contains(product)
          || products.firstWhere((element) => element.prdId==product!.prdId,orElse: ()=> Product(prdId: null)).prdId!=null){
        print("cart contains product");
        products[products.indexWhere((element) => element.prdId==product!.prdId)].cartQuantity
        = products[products.indexWhere((element) => element.prdId==product!.prdId)].cartQuantity-1;
        if(products[products.indexWhere((element) => element.prdId==product!.prdId)].cartQuantity==0){
          products.removeAt(products.indexWhere((element) => element.prdId==product!.prdId));
        }
      }
      update();
      calculateTotal();
      calculateTotalProducts();
      return;
    }
    if(products.contains(product)
        || products.firstWhere((element) => element.prdId==product!.prdId,orElse: ()=> Product(prdId: null)).prdId!=null){
      products[products.indexWhere((element) => element.prdId==product!.prdId)].cartQuantity
      = products[products.indexWhere((element) => element.prdId==product!.prdId)].cartQuantity+1;
    }else{
      products.add(product!..cartQuantity=1);
    }
    calculateTotal();
    calculateTotalProducts();
    update();
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


}