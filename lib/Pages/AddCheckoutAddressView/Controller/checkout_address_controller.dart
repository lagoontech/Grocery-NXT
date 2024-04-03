import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../Models/countries_model.dart';
import '../Models/states_model.dart';

class AddCheckoutAddressController extends GetxController{

  bool loadingAddresses = false;
  bool loadingCountries = false;
  bool loadingStates    = false;
  List<Country?> countries = [];
  List<CountryState?> states    = [];
  CountryState ?selectedState;
  Country ?selectedCountry;
  Timer ?searchTimer;
  TextEditingController searchTEC  = TextEditingController();
  TextEditingController stateSearchTEC  = TextEditingController();
  TextEditingController countryTEC = TextEditingController();
  TextEditingController stateTEC   = TextEditingController();

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
      print(e);
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
  debounceSearch({bool isStateSearch = false}){

    if(searchTimer!=null && searchTimer!.isActive){
      searchTimer!.cancel();
      return;
    }
    searchTimer = Timer(const Duration(milliseconds: 750), () {
      if(isStateSearch){
        getStates();
        return;
      }
      getCountries();
    });
  }

 @override
  void onInit() {
    super.onInit();
    getCountries();
  }

  @override
  void dispose() {
    searchTimer!.cancel();
    super.dispose();
  }

}