import 'dart:developer';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import '../../HomeScreen/Models/home_categories_model.dart';
import '../Model/products_list_model.dart';

class AllProductsController extends GetxController{

  bool isLoading = false;
  bool isLoadingCategories = false;
  List<Product> products = [];
  int page = 1;
  List<CategoryModel?> categories = [CategoryModel(id: 0,imageUrl: "",name: "All")];
  CategoryModel ?selectedCategory = CategoryModel(name: "");
  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  //
  fetchProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    if(isRefresh){
      isLoading = true;
    }
    if(isLoadingNext){
      page++;
    }
    update();
    try{
      var result = await HttpService.getRequest(
          "${ApiConstants().allProducts}?page=$page&category=${selectedCategory!.name=="All"?"":selectedCategory!.name}");
      if(result is http.Response){
        if(result.statusCode==200){
          if(isRefresh) {
            products = productsListFromJson(result.body).products!;
          }else{
            products.addAll(productsListFromJson(result.body).products!);
          }
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    isLoading = false;
    update();
  }

  //
  fetchCategories()async{

    isLoadingCategories = true;
    update();
    try{
      var result = await HttpService.getRequest(ApiConstants().categories);
      if(result is http.Response){
        if(result.statusCode == 200 || result.statusCode==201){
          categories.addAll(homeCategoriesModelFromJson(result.body)!.categories!);
        }
      }
    }catch(e){
      if (kDebugMode) {
        print("Home Categories Error-->$e");
      }
    }
    isLoadingCategories = false;
    update();
  }

  //
  onTabBarTapped(int index){

    selectedCategory = categories[index];
    update();
    fetchProducts(isRefresh: true);
  }


  //
  @override
  void onInit() {
    super.onInit();
    fetchProducts(isRefresh: true);
    fetchCategories();
  }

}