import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../HomeScreen/Models/home_categories_model.dart';
import '../Model/products_list_model.dart';

class AllProductsController extends GetxController with GetTickerProviderStateMixin{

  bool isLoading = false;
  bool isLoadingCategories = false;
  List<Product> products = [];
  int page = 1;
  List<CategoryModel?> categories = [CategoryModel(id: 0,imageUrl: "",name: "All Products")];
  CategoryModel ?selectedCategory = CategoryModel(name: "");
  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  TabController ?tabController;
  RefreshController refreshController = RefreshController();
  ScrollController sc = ScrollController();
  bool showNextLoading = false;
  bool isLoadingNextPage = false;

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
          "${ApiConstants().allProducts}?page=$page&category=${selectedCategory!.name=="All Products"?"":selectedCategory!.name}");
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
    isLoadingNextPage = false;
    showNextLoading = false;
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
          tabController = TabController(length: categories.length, vsync: this);
          tabController!.animateTo(categories.indexWhere((element) => element!.id==selectedCategory!.id));
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
  loadNextPageCheck(){
      sc.addListener(() {
        if((sc.position.userScrollDirection==ScrollDirection.reverse
            &&sc.position.maxScrollExtent-sc.position.pixels<=10&&!showNextLoading)
   ){
          print("loadnext");
          showNextLoading = true;
          fetchProducts(isLoadingNext: true);
          update();
        }
      });
  }


  //
  @override
  void onInit() {
    super.onInit();
    //fetchProducts(isRefresh: true);
    fetchCategories();
    loadNextPageCheck();
  }

  @override
  void dispose() {
    tabController!.dispose();
    sc.dispose();
    super.dispose();
  }

}