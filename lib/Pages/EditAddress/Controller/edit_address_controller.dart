import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Models/shipping_addresses_model.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/cart_controller.dart';
import 'package:grocery_nxt/Pages/ProfileView/Controller/profile_controller.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import 'package:http/http.dart' as http;
import '../../AddCheckoutAddressView/Models/states_model.dart';
import '../../RegisterScreen/Models/cities_model.dart';

class EditAddressController extends GetxController{

  bool loadingAddresses       = false;
  bool loadingCountries       = false;
  bool loadingStates          = false;
  bool fetchingShippingCharge = false;
  bool creatingAddress        = false;
  List<CountryState?> states  = [];
  List<City> cities  = [];
  CountryState ?selectedState;
  City ?selectedCity;
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
  int ?addressId;
  ShippingAddress ?address;

  ProfileController profileController = Get.find<ProfileController>();



  //
  chooseAddress(){

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

    var address = ShippingAddress(
      id: addressId,
      name: titleTEC.text,
      email: emailTEC.text,
      phone: phoneTEC.text,
      userId: profileController.profile!.userDetails!.id,
      countryId: 70,
      stateId: selectedState!.id,
      zipCode: zipcodeTEC.text,
      address: addressTEC.text,
    );

    Get.back(result: address);

  }

  //
  getCountries() async{

    loadingCountries = true;
    update();
    try{
      var result = await HttpService.getRequest("country?name=${searchTEC.text}");
      if(result is http.Response){
        if(result.statusCode==200){}
      }
    } catch(e){
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
          "get-cities/${selectedState!.id}${citySearchTEC.text.isNotEmpty?"?name=${citySearchTEC.text}":""}&page=1");
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
  editAddress() async{

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
    print("updated city id-->${selectedCity!.id}");
    print("updated state id -->${selectedState!.id}");
    log({
      "id": addressId,
      "name": titleTEC.text,
      "email": emailTEC.text,
      "phone": phoneTEC.text,
      "country": "70",
      "address": addressTEC.text,
      "zip_code": zipcodeTEC.text,
      "user_id": profileController.profile!.userDetails!.id,
      "city": selectedCity!.name,
      "state": selectedState!.id,
      "shipping_address_name": titleTEC.text
    }.toString());
    try{
      var result = await HttpService.postRequest("user/add-shipping-address",{
        "id": addressId,
        "name": titleTEC.text,
        "email": emailTEC.text,
        "phone": phoneTEC.text,
        "country": "70",
        "address": addressTEC.text,
        "zip_code": zipcodeTEC.text,
        "user_id": profileController.profile!.userDetails!.id,
        "city": selectedCity!.name,
        "state": selectedState!.id,
        "shipping_address_name": titleTEC.text
      },insertHeader: true);
      if(result is http.Response){
        if(result.statusCode==200){
          Get.back(result: true);
        }
      }
    } catch(e){
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
      final Uri uri = Uri.parse('http://grocerynxt.com/api/shippingaddresszipcode_weight.php');
      final map = <String, dynamic>{};
      map['zipcode']    = zipcodeTEC.text;
      map['overall_weight'] = cc.weight.toString();
      http.Response result = await http.post(
        uri,
        body: map,
      );
      if(result.statusCode == 200){
        shippingCost = jsonDecode(result.body)["finalcost"].toString();
      }
    }catch(e){

    }
    fetchingShippingCharge = false;
    update();

  }

  //
  setAddressValues(){

    titleTEC.text   = address!.name;
    addressTEC.text = address!.address!;
    emailTEC.text   = address!.email;
    phoneTEC.text   = address!.phone;
    zipcodeTEC.text = address!.zipCode!;
    if(address!.state!=null) {
      stateTEC.text = address!.state!.name;
    }
    if(address!.city!=null){
      cityTEC.text    = address!.city!.name;
      selectedCity    = City(name: address!.city!.name,id: addressId);
    }
    selectedState   = CountryState(id: address!.state!.id,name: address!.state!.name,countryId: address!.country!.id);

  }

  @override
  void onInit() {
    super.onInit();
    if(kDebugMode){
      titleTEC.text = "Office";
      emailTEC.text = "anlin.jude.7@gmail.com";
      phoneTEC.text = "";
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