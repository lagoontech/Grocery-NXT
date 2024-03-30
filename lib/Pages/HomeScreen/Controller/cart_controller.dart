import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../AllProductsView/Model/products_list_model.dart';

class CartController extends GetxController{

  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  List<Product> products = [];

  //
  addToCart({Product ?product,bool isSub = false,bool showToast = true}){
    
    if(isSub){
      if(products.contains(product)){
        products[products.indexOf(product!)].cartQuantity
        = products[products.indexOf(product)].cartQuantity-1;
        if(products[products.indexOf(product)].cartQuantity==0){
          products.remove(product);
        }
      }
      update();
      return;
    }
    if(products.contains(product)
        || products.firstWhere((element) => element.prdId==product!.prdId,orElse: ()=> Product(prdId: null)).prdId!=null){
      products[products.indexWhere((element) => element.prdId==product!.prdId)].cartQuantity
      = products[products.indexWhere((element) => element.prdId==product!.prdId)].cartQuantity+1;
    }else{
      products.add(product!..cartQuantity=1);
    }
    update();
  }


}