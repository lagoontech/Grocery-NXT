import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CartController extends GetxController{

  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

}