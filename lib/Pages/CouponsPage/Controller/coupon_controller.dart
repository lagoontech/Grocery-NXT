import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../Models/coupons_list_model.dart';

class CouponController extends GetxController{

  bool loading = false;
  List<Coupon> coupons = [];

  //
  getCoupons() async{

    loading = true;
    update();
    try{
      var result = await HttpService.getRequest("getallcoupon");
      if(result is http.Response){
        if(result.statusCode == 200){
          coupons = couponsModelFromJson(result.body).coupon!;
      }}
    }catch(e){
      print(e);
    }
    loading = false;
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    getCoupons();
  }

}