import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../../HomeScreen/Controller/cart_controller.dart';
import '../Models/shipping_addresses_model.dart';

class ChooseAddressController extends GetxController{

  bool loadingAddresses = false;
  List<ShippingAddress> addresses = [];
  dynamic selectedAddressId;
  ShippingAddress ?selectedAddress;
  bool fetchingShippingCharge = false;
  String shippingCharge = "0.00";
  bool showCOD = true;
  double finalTotal = 0.00;
  ScrollController scrollController = ScrollController();

  //
  getAddresses() async {

    loadingAddresses = true;
    update();
    try{
      var result = await HttpService.getRequest("user/all-shipping-address");
      if(result is http.Response){
        print(result.body);
        if(result.statusCode == 200){
          addresses = shippingAddressListModelFromJson(result.body).data;
          print(addresses.length);
        }
      }
    }catch(e){
      print(e);
    }
    loadingAddresses = false;
    update();
  }

  //
  getShippingCharge() async {

    CartController cc = Get.find<CartController>();
    String products_ids = "";
    fetchingShippingCharge = true;
    update();
    try{
      for (var element in cc.products) {
        products_ids = "$products_ids${element.prdId},";
      }
      final Uri uri = Uri.parse('http://grocerynxt.lagoontechcloud.com/api/shippingaddresszipcode.php');
      final map = <String, dynamic>{};
      map['zipcode']    = selectedAddress!.zipCode;
      map['productids'] = products_ids;
      http.Response result = await http.post(
        uri,
        body: map,
      );
      if(result is http.Response){
        print(result.statusCode);
        if(result.statusCode == 200){
          shippingCharge = jsonDecode(result.body)["finalcost"];
          showCOD = jsonDecode(result.body)["exclude"]=='0'?false:true;
          finalTotal = double.parse(shippingCharge) + cc.total;
          print(finalTotal);
        }else{
          finalTotal = cc.total;
        }
      }
    }catch(e){
      print(e);
      fetchingShippingCharge = false;
    }
    fetchingShippingCharge = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    getAddresses();
  }

}