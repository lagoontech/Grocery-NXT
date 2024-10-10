import 'dart:async';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Models/home_categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../Constants/api_constants.dart';
import '../../../Services/http_services.dart';
import '../../AllProductsView/Model/products_list_model.dart';

class ProductsSearchController extends GetxController{

  Timer ?searchTimer;
  TextEditingController searchTEC = TextEditingController();
  ScrollController sc = ScrollController();
  RefreshController refreshTEC = RefreshController();
  late Function(GlobalKey) runAddToCartAnimation;
  int page = 1;
  List<Product> searchedProducts = [];
  bool loading = false;
  bool showNextLoading = false;
  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  HomeController hc = Get.find<HomeController>();
  List<CategoryModel> suggestedCategories = [];
  CategoryModel ?selectedCategory;
  FocusNode focusNode = FocusNode();
  int searchLength = 0;

  //
  listenToSearch(){

    selectedCategory = null;
    if(searchTimer!=null && searchTimer!.isActive){
        searchTimer!.cancel();
      }
      searchTimer = Timer(const Duration(milliseconds: 750), () {
        if(searchTEC.text.isNotEmpty) {
          searchLength = searchTEC.text.length;
          page = 1;
          searchProducts();
        }
      });

  }

  //
  searchProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    if(isLoadingNext) {
      showNextLoading = true;
      page++;
    }else{
      searchedProducts.clear();
      loading = true;
    }
    update();
    try{
      var result = await HttpService.getRequest(
          "${ApiConstants().allProducts}?name=${searchTEC.text}&page=$page${selectedCategory!=null?"&category=${selectedCategory!.name}":""}");
      if(result is http.Response){
        if(result.statusCode==200){
            searchedProducts.addAll(productsListFromJson(result.body).products!);
            if(searchTEC.text.isNotEmpty) {
              suggestedCategories.clear();
              for (var element in hc.categories) {
                if (element!.name!.toLowerCase() == searchTEC.text.toLowerCase()
                    || element.name!.toLowerCase().contains(searchTEC.text.toLowerCase())
                    || element.name!.toLowerCase().startsWith(searchTEC.text.toLowerCase())) {
                  suggestedCategories.add(element);
                }
              }
            }
            focusNode.unfocus();
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loading = false;
    showNextLoading = false;
    update();

  }

  //
  loadNextPageCheck(){
    sc.addListener(() {
      if((sc.position.userScrollDirection==ScrollDirection.reverse
          &&sc.position.maxScrollExtent-sc.position.pixels<=10&&!showNextLoading)
      ){
        print("loadnext");
        showNextLoading = true;
        searchProducts(isLoadingNext: true);
        update();
      }
    });
  }

  //
  @override
  void onInit() {
    super.onInit();
    listenToSearch();
    loadNextPageCheck();
  }

}