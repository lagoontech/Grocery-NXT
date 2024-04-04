import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../Models/shipping_addresses_model.dart';

class ChooseAddressController extends GetxController{

  bool loadingAddresses = false;
  List<ShippingAddress> addresses = [];
  dynamic selectedAddressId;
  ShippingAddress ?selectedAddress;

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
  @override
  void onInit() {
    super.onInit();
    getAddresses();
  }

}