import 'dart:async';
import 'dart:developer';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/AllProductsView/Model/products_list_model.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Models/sub_categories_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../Constants/api_constants.dart';
import '../../HomeScreen/Models/home_categories_model.dart';

class SwiggyViewController extends GetxController with GetTickerProviderStateMixin{

  int ?categoryId;
  int subIndex = 0;
  int ?subCategoryId;
  String ?categoryName;
  List<Subcategory> subCategories = [];
  Subcategory ?selectedSubCategory;
  List<Product> products = [];
  HomeController hc = Get.find<HomeController>();
  bool isLoading = true;
  bool isLoadingSubCategories = false;
  bool initialLoading = true;
  int page = 1;
  bool isLastPage = false;
  bool isAnimatingToNext = false;
  List<CategoryModel?> categories = [];
  CategoryModel ?selectedCategory = CategoryModel(name: "");
  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  TabController ?tabController;
  RefreshController refreshController = RefreshController();
  bool showNextLoading   = false;
  bool isLoadingNextPage = false;
  TextEditingController searchTEC = TextEditingController();
  ScrollController scrollController = ScrollController();
  ScrollController noSubScrollController = ScrollController();
  PageController pageController     = PageController();
  Timer ?searchTimer;
  int totalProducts = 0;
  int totalCategoryProducts = 0;
  double scrollOffset = 0;
  GlobalKey selectedKey = GlobalKey();
  Timer ?pageScrollTimer;
  RangeValues ?filterPriceRange = const RangeValues(1,1500);
  bool somethingWentWrong = false;

  //
  fetchSubCategories() async {

    isLoadingSubCategories = true;
    somethingWentWrong = false;
    update();
    try{
      var result = await HttpService.getRequest("subcategory/$categoryId");
      if(result is http.Response){
        if(result.statusCode==200){
          log(result.body);
          subCategories = subcategoriesModelFromJson(result.body).subcategories!;
          for(int i=0;i<subCategories.length;i++){
            subCategories[i].positionKey = GlobalKey();
            subCategories[i].scrollController = ScrollController();
          }
          if(subCategories.isNotEmpty) {
            selectedSubCategory = subCategories[0];
          }
          if(subCategoryId!=null){
            selectedSubCategory = subCategories.firstWhere((element) => element.id==subCategoryId);
          }
          fetchProducts(isRefresh: true);
          attachScrollListeners();
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      somethingWentWrong = true;
    }
    isLoadingSubCategories = false;
    update();
    Future.delayed(const Duration(milliseconds: 1000),(){
      if(subCategoryId!=null){
        findCategoryIndicatorOffset();
      }
    });
  }

  //
  fetchProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    somethingWentWrong = false;
    if(isLoadingNextPage){
      return;
    }
    if(isRefresh){
      isLoading = true;
      page = 1;
      isLastPage = false;
    }
    if(isLoadingNext){
      isLoadingNextPage = true;
      page++;
    }
    update();
    try{
      var result = await HttpService.getRequest(
          "${ApiConstants().allProducts}?name=${searchTEC.text}&page=$page&category=$categoryName&sub_category=${selectedSubCategory!=null?selectedSubCategory!.name:""}&min_price=${filterPriceRange!.start}&max_price=${filterPriceRange!.end}");
      if(result is http.Response){
        if(result.statusCode==200){
          if(isRefresh) {
            products = productsListFromJson(result.body).products!;
          }else{
            products.addAll(productsListFromJson(result.body).products!);
          }
          totalProducts = productsListFromJson(result.body).meta!.total!;
          if(productsListFromJson(result.body).meta!.lastPage==page){
            isLastPage = true;
          }
          if(isLoadingNext){
            selectedSubCategory!.scrollController!.animateTo(
            selectedSubCategory!.scrollController!.position.maxScrollExtent+450.h,
            duration: const Duration(milliseconds: 750), curve: Curves.linear);
          }
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
        somethingWentWrong = true;
      }
    }
    isLoading = false;
    isLoadingNextPage = false;
    initialLoading  = false;
    showNextLoading = false;
    update();
    listenToSubListScroll();
  }

  //
  scrollUp(){}

  //
  fetchCategoryProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    try{
      var result = await HttpService.getRequest(
          "${ApiConstants().allProducts}?name=${searchTEC.text}&page=$page&category=$categoryName");
      if(result is http.Response){
        if(result.statusCode==200){
          totalCategoryProducts = productsListFromJson(result.body).meta!.total!;
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update();
  }

  //
  attachScrollListeners(){

    if(subCategories.isEmpty){
      noSubScrollController.addListener(() {
        double pos = noSubScrollController.position.pixels;
        double max = noSubScrollController.position.maxScrollExtent;
        if(pos-max>40.h&& !isLastPage && !isLoadingNextPage && !isAnimatingToNext){
          fetchProducts(isLoadingNext: true);
        }
        if(pageScrollTimer!=null&&pageScrollTimer!.isActive){
          pageScrollTimer!.cancel();
        }
        pageScrollTimer = Timer(const Duration(milliseconds: 10),(){
          if(isLastPage && (pos-max)>70.h && !isAnimatingToNext){
            isAnimatingToNext = true;
            selectedSubCategory = subCategories[subIndex+1];
            findCategoryIndicatorOffset();
            pageController.animateToPage(
                subIndex+1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutSine).then((value){
              isAnimatingToNext = false;
            });
            fetchProducts(isRefresh: true);
          } else if(pos<-70.h && !isAnimatingToNext){
            isAnimatingToNext = true;
            selectedSubCategory = subCategories[subIndex-1];
            findCategoryIndicatorOffset();
            pageController.animateToPage(
                subIndex-1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutSine).then((value){
              isAnimatingToNext = false;
            });
            fetchProducts(isRefresh: true);
          }
        });
      });
    }
    for (int i=0;i<subCategories.length;i++) {
      subCategories[i].scrollController!.addListener(() {
        double pos = subCategories[i].scrollController!.position.pixels;
        double max = subCategories[i].scrollController!.position.maxScrollExtent;
        if(pos-max>40.h&& !isLastPage && !isLoadingNextPage && !isAnimatingToNext){
          fetchProducts(isLoadingNext: true);
        }
        if(pageScrollTimer!=null&&pageScrollTimer!.isActive){
          pageScrollTimer!.cancel();
        }
        pageScrollTimer = Timer(const Duration(milliseconds: 10),(){
          if(isLastPage && (pos-max)>70.h && !isAnimatingToNext){
            isAnimatingToNext = true;
            selectedSubCategory = subCategories[subIndex+1];
            findCategoryIndicatorOffset();
            pageController.animateToPage(
                subIndex+1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutSine).then((value){
                  isAnimatingToNext = false;
            });
            fetchProducts(isRefresh: true);
          } else if(pos<-70.h && !isAnimatingToNext){
            isAnimatingToNext = true;
            selectedSubCategory = subCategories[subIndex-1];
            findCategoryIndicatorOffset();
            pageController.animateToPage(
                subIndex-1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutSine).then((value){
              isAnimatingToNext = false;
            });
            fetchProducts(isRefresh: true);
          }
        });
      });
    }
  }

  //
  findCategoryIndicatorOffset() {

    selectedKey = selectedSubCategory!.positionKey!;
    subIndex = subCategories.indexOf(selectedSubCategory!);
    RenderBox? renderBox = selectedKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Offset localOffset = renderBox.localToGlobal(Offset.zero);
      scrollOffset = localOffset.dy-100.h;
      print("scroll offset-->${scrollOffset}");
      update();
    }
  }

  //
  listenToSubListScroll(){

    scrollController.addListener(() {
      RenderBox? renderBox = selectedKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        Offset localOffset = renderBox.localToGlobal(Offset.zero);
        scrollOffset = localOffset.dy-100.h;
        update();
      }
    });
  }

  //
  @override
  void onInit() {
    super.onInit();
    categories = hc.categories;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

}