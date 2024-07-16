import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Models/home_campaign_model.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Models/sub_categories_model.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../AllProductsView/Model/products_list_model.dart';
import '../Models/carousel_model.dart';
import '../Models/home_categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class HomeController extends GetxController{

  ScrollController sc                   = ScrollController();
  ScrollController homeSc               = ScrollController();
  ScrollController productsSc           = ScrollController();
  ScrollController autoScroll1          = ScrollController();
  ScrollController autoScroll2          = ScrollController();
  CarouselController carouselController = CarouselController();
  int carouselIndex = 0;
  int bottomIndex   = 0;
  double categoryScrollProgress        = 0.0;
  double currentCategoryScrollProgress = 0.0;
  Timer ?autoScrollTimer;
  bool reverseScroll     = false;
  List<Product> products = [];
  List<Product> featuredProducts   = [];
  List<CategoryModel?> categories  = [];
  List<Subcategory> subcategories1 = [];
  List<Subcategory> subcategories2 = [];
  List<Subcategory> subcategories3 = [];
  List<Carousel> carousels = [];
  List<Carousel> carousels2 = [];
  bool loadingCarousel     = false;
  HomeCampaignsModel ?campaign;
  int currentCarouselIndex = 0;

  //
  fetchCategories()async{

    try{
      var result = await HttpService.getRequest(ApiConstants().categories);
      if(result is http.Response){
        if(result.statusCode == 200 || result.statusCode==201){
          categories = homeCategoriesModelFromJson(result.body)!.categories!;
        }
      }
    }catch(e){
      if (kDebugMode) {
        print("Home Categories Error-->$e");
      }
    }
    update(["categories"]);
  }

  //
  fetchCampaigns() async {

    update();
    try{
      var result = await HttpService.getRequest("campaign");
      if(result is http.Response){
        if(result.statusCode==200){
          campaign = HomeCampaignsModel.fromJson(jsonDecode(result.body));
          print(campaign!.data![0]!.image);
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
  fetchProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    update();
    try{
      var result = await HttpService.getRequest(
          "${ApiConstants().allProducts}?page=1");
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
    update();
  }

  //
  fetchSubCategories() async {

    update(["category_1"]);
    try{
      var result = await HttpService.getRequest("subcategory/23");
      if(result is http.Response){
        if(result.statusCode==200){
          subcategories1.addAll(subcategoriesModelFromJson(result.body).subcategories!);
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update(["category_1"]);
  }

  //
  fetchSubCategories2() async {

    update(["category_2"]);
    try{
      var result = await HttpService.getRequest("subcategory/38");
      if(result is http.Response){
        if(result.statusCode==200){
          subcategories2.addAll(subcategoriesModelFromJson(result.body).subcategories!);
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update(["category_2"]);
  }

  //
  fetchSubCategories3() async {

    update(["category_3"]);
    try{
      var result = await HttpService.getRequest("subcategory/32");
      if(result is http.Response){
        if(result.statusCode==200){
          subcategories3.addAll(subcategoriesModelFromJson(result.body).subcategories!);
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update(["category_3"]);
  }

  //
  fetchFeaturedProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    try{
      var result = await HttpService.getRequest(
          "featured/${ApiConstants().allProducts}");
      if(result is http.Response){
        if(result.statusCode==200){
          if(isRefresh) {
            featuredProducts = productsListFromJson(result.body).products!;
          }else{
            featuredProducts.addAll(productsListFromJson(result.body).products!);
          }
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update(["featured_products"]);
  }

  //
  Future<Color> getImagePalette(String imageUrl) async {

    final response      = await http.get(Uri.parse(imageUrl));
    final image         = img.decodeImage(response.bodyBytes);
    final imageProvider = MemoryImage(Uint8List.fromList(img.encodePng(image!)));
    final PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }

  //
  fetchCarousel1() async {

    loadingCarousel = true;
    update(["carousel"]);
    try {
      var result = await HttpService.getRequest("mobile-slider/1");
      if(result is http.Response){
        if(result.statusCode == 200 || result.statusCode == 201){
          carousels = carouselModelFromJson(result.body).data!;
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loadingCarousel = false;
    update(["carousel"]);
  }

  //
  fetchCarousel2() async {

    loadingCarousel = true;
    update(["carousel2"]);
    try {
      var result = await HttpService.getRequest("mobile-slider/2");
      if(result is http.Response){
        if(result.statusCode == 200 || result.statusCode == 201){
          carousels2 = carouselModelFromJson(result.body).data!;
        }
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    loadingCarousel = false;
    update(["carousel2"]);
  }

  //
  /*autoScrollProducts() async {
    update();
    await Future.delayed(const Duration(milliseconds: 5000));
    autoScroll1.animateTo(
    autoScroll1.position.maxScrollExtent,
    duration: const Duration(seconds: 150),
    curve: Curves.linear);
    autoScroll2.animateTo(
    autoScroll2.position.maxScrollExtent,
    duration: const Duration(seconds: 150),
    curve: Curves.linear);
  }*/

  //
  calculateCurrentScrollPosition(){

    final maxScrollExtent = sc.position.maxScrollExtent;
    final currentScrollOffset = sc.position.pixels;
    categoryScrollProgress = currentCategoryScrollProgress;
    if(!currentScrollOffset.isNegative) {
      currentCategoryScrollProgress = (currentScrollOffset / maxScrollExtent);
    }
    update(["scrollIndicator"]);
  }

  //
  carouselChange(){

  }

  //
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts(isRefresh: true);
    fetchFeaturedProducts();
    fetchCarousel1();
    fetchCampaigns();
    fetchSubCategories();
    fetchSubCategories2();
    fetchSubCategories3();
    sc.addListener(() {
      calculateCurrentScrollPosition();
      update();
    });

  }

  @override
  void dispose() {
    sc.dispose();
    autoScrollTimer!.cancel();
    super.dispose();
  }

}