import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../Models/shipping_addresses_model.dart';

class ChooseAddressController extends GetxController{

  bool loadingAddresses = false;
  List<ShippingAddress> addresses = [];

  //
  getAddresses() async {

    loadingAddresses = true;
    update();
    try{
      var result = await HttpService.getRequest("user/all-shipping-address");
      if(result is http.Response){
        if(result.statusCode == 200){
          addresses = shippingAddressListModelFromJson(result.body).data;
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