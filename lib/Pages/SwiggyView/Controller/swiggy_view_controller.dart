import 'dart:async';
import 'dart:developer';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Model/products_list_model.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Models/sub_categories_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../Constants/api_constants.dart';
import '../../HomeScreen/Models/home_categories_model.dart';

class SwiggyViewController extends GetxController{

  int ?categoryId;
  String ?categoryName;
  List<Subcategory> subCategories = [];
  Subcategory ?selectedSubCategory;
  List<Product> products = [];

  bool isLoading = false;
  bool isLoadingCategories = false;
  bool initialLoading = true;
  int page = 1;
  List<CategoryModel?> categories = [CategoryModel(id: 0,imageUrl: "",name: "All Products")];
  CategoryModel ?selectedCategory = CategoryModel(name: "");
  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  TabController ?tabController;
  RefreshController refreshController = RefreshController();
  ScrollController sc    = ScrollController();
  bool showNextLoading   = false;
  bool isLoadingNextPage = false;
  TextEditingController searchTEC = TextEditingController();
  Timer ?searchTimer;
  int totalProducts = 0;


  //
  fetchSubCategories() async {

    try{
      var result = await HttpService.getRequest("subcategory/$categoryId");
      if(result is http.Response){
        if(result.statusCode==200){
          log(result.body);
        }
        subCategories = subcategoriesModelFromJson(result.body).subcategories!;
        selectedSubCategory = subCategories[0];
        fetchProducts(isRefresh: true);
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update();
  }

  //
  fetchProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    if(isLoadingNextPage){
      return;
    }
    if(isRefresh){
      isLoading = true;
      page = 1;
    }
    if(isLoadingNext){
      isLoadingNextPage = true;
      page++;
    }
    update();
    try{
      var result = await HttpService.getRequest(
          "${ApiConstants().allProducts}?name=${searchTEC.text}&page=$page&category=$categoryName&sub_category=${selectedSubCategory!.name}");
      if(result is http.Response){
        if(result.statusCode==200){
          if(isRefresh) {
            products = productsListFromJson(result.body).products!;
          }else{
            products.addAll(productsListFromJson(result.body).products!);
          }
          totalProducts = productsListFromJson(result.body).meta!.total!;
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    isLoading = false;
    isLoadingNextPage = false;
    initialLoading  = false;
    showNextLoading = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

}