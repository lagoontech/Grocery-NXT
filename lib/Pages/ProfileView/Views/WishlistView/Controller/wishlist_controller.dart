import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import '../../../../AllProductsView/Model/products_list_model.dart';

class WishlistController extends GetxController{

  List<Product> products = [];

  //
  addOrRemoveProduct({bool ?isFavourite,Product ?product}){

    if(isFavourite!){
      products.removeWhere((element) => element.prdId == product!.prdId);
      update();
      ToastUtil().showToast(message: "Product removed",color: Colors.red);
      return;
    }
    products.add(product!);
    SharedPrefUtils.pref!.setStringList("wishlist",products.map((e) => jsonEncode(e.toJson())).toList());
    ToastUtil().showToast(message: "Product added",color: AppColors.primaryColor);
    update();
  }

  //
  clearWishList(){

    SharedPrefUtils.pref!.setStringList("wishlist",products.map((e) => jsonEncode(e.toJson())).toList());
  }

  //
  fetchWishlist(){

    if(SharedPrefUtils.pref!.containsKey("wishlist")){
      for (var element in SharedPrefUtils.pref!.getStringList("wishlist")!) {
        products.add(Product.fromJson(jsonDecode(element)));
      }
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

}