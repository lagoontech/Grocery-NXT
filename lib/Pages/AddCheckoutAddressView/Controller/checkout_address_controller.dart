import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/ProfileView/Controller/profile_controller.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;
import '../../RegisterScreen/Models/cities_model.dart';
import '../Models/countries_model.dart';
import '../Models/states_model.dart';

class AddCheckoutAddressController extends GetxController{

  bool loadingAddresses       = false;
  bool loadingCountries       = false;
  bool loadingStates          = false;
  bool fetchingShippingCharge = false;
  bool creatingAddress        = false;
  List<Country?> countries    = [];
  List<CountryState?> states  = [];
  List<City> cities  = [];
  CountryState ?selectedState;
  City ?selectedCity;
  Country ?selectedCountry;
  Timer ?searchTimer;
  TextEditingController searchTEC       = TextEditingController();
  TextEditingController stateSearchTEC  = TextEditingController();
  TextEditingController citySearchTEC   = TextEditingController();
  TextEditingController countryTEC      = TextEditingController();
  TextEditingController titleTEC        = TextEditingController();
  TextEditingController emailTEC        = TextEditingController();
  TextEditingController phoneTEC        = TextEditingController();
  TextEditingController addressTEC      = TextEditingController();
  TextEditingController zipcodeTEC      = TextEditingController();
  TextEditingController orderNoteTEC    = TextEditingController();
  TextEditingController stateTEC        = TextEditingController();
  TextEditingController cityTEC         = TextEditingController();
  String shippingCost                   = "";

  //
  getCountries()async{

    loadingCountries = true;
    update();
    try{
      var result = await HttpService.getRequest("country?name=${searchTEC.text}");
      if(result is http.Response){
        if(result.statusCode==200){
          countries = countryModelFromJson(result.body)!.countries!;
          selectedCountry = countries[0];
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loadingCountries = false;
    update();
  }

  //
  getStates() async {

    loadingStates = true;
    update();
    try{
      var result = await HttpService.getRequest("state/70?name=${stateSearchTEC.text}");
      if(result is http.Response){
        if(result.statusCode==200){
          states = stateModelFromJson(result.body)!.states!;
          selectedState = states[0];
        }
      }
    }catch(e){
      print(e);
    }
    loadingStates = false;
    update();
  }

  //
  getCities() async {

    loadingStates = true;
    update();
    try{
      var result = await HttpService.getRequest(
          "get-cities/${selectedState!.id}${citySearchTEC.text.isNotEmpty?"?name=${citySearchTEC.text}":""}");
      if(result is http.Response){
        if(result.statusCode==200){
          cities = citiesModelFromJson(result.body).cities!;
        }
      }
    }catch(e){
      print(e);
    }
    loadingStates = false;
    update();

  }

  //
  debounceSearch({bool isStateSearch = false,bool isCitySearch = false}){

    if(searchTimer!=null && searchTimer!.isActive){
      searchTimer!.cancel();
      return;
    }
    searchTimer = Timer(const Duration(milliseconds: 750), () {
      if(isStateSearch){
        getStates();
        return;
      }else if(isCitySearch){
        getCities();
        return;
      }
      getCountries();
    });
  }

  //
  createAddress()async{

    ProfileController profileController = Get.find<ProfileController>();
    if(selectedState==null){
      ToastUtil().showToast(message: "Please select a state");
      return;
    }
    if(selectedCity==null){
      ToastUtil().showToast(message: "Please select a city");
      return;
    }
    if(zipcodeTEC.text.isEmpty || zipcodeTEC.text.length!=6){
      ToastUtil().showToast(message: "Please enter a valid zipcode");
      return;
    }
    if(titleTEC.text.isEmpty){
      ToastUtil().showToast(message: "Please enter title");
      return;
    }
    creatingAddress = true;
    update();
    try{
      var result = await HttpService.postRequest("user/add-shipping-address",{
        "name": titleTEC.text,
        "email": emailTEC.text,
        "phone": phoneTEC.text,
        "country": "70",
        "address": addressTEC.text,
        "zip_code": zipcodeTEC.text,
        "user_id": profileController.profile!.userDetails!.id,
        "city": selectedCity!.id,
        "state": selectedState!.id,
        "shipping_address_name": titleTEC.text
      },insertHeader: true);
      if(result is http.Response){
        print(result.body);
        if(result.statusCode==200){
          Get.back(result: 1);
        }else{
          print(result.body);
        }
      }
    }catch(e){
      print(e);
    }
    creatingAddress = false;
    update();
  }

  //
  getShippingCharge() async {

    String products_ids = "";
    String size_ids     = "";
    String quantity_ids = "";
    fetchingShippingCharge = true;
    update();
    try{
      CartController cc = Get.find<CartController>();
      for (var element in cc.products) {
        products_ids = "$products_ids${element.prdId},";
        if(element.variantInfo!=null){
          size_ids = "$size_ids${element.prdId}_${element.productColor!.name},";
        }
        quantity_ids = "$quantity_ids${element.cartQuantity},";
      }
      final Uri uri = Uri.parse('http://grocerynxt.lagoontechcloud.com/api/shippingaddresszipcode.php');
      final map = <String, dynamic>{};
      map['zipcode']    = zipcodeTEC.text;
      map['productids'] = products_ids;
      map['sizeid']     = size_ids;
      map['qtyvid']     = quantity_ids;
      http.Response result = await http.post(
        uri,
        body: map,
      );
      print(map);
      if(result.statusCode == 200){
        shippingCost = jsonDecode(result.body)["finalcost"].toString();
        print(shippingCost);
      }
        }catch(e){
      print(e);
    }
    fetchingShippingCharge = false;
    update();
  }

 @override
  void onInit() {
    super.onInit();
    if(kDebugMode){
      titleTEC.text = "Office";
      emailTEC.text = "anlin.jude.7@gmail.com";
      phoneTEC.text = "9080761312";
      stateTEC.text = "TamilNadu";
      addressTEC.text = "Sree sai Complex1";
      zipcodeTEC.text = "629157";
    }
    getCountries();
  }

  @override
  void dispose() {
    searchTimer!.cancel();
    super.dispose();
  }

}