import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../AllProductsView/Model/products_list_model.dart';
import '../Models/carousel_model.dart';
import '../Models/home_categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class HomeController extends GetxController{

  ScrollController sc = ScrollController();
  ScrollController homeSc = ScrollController();
  ScrollController productsSc = ScrollController();
  int bottomIndex = 0;
  double categoryScrollProgress = 0.0;
  double currentCategoryScrollProgress = 0.0;
  Timer ?autoScrollTimer;
  bool reverseScroll = false;
  List<Product> products = [];
  List<Product> featuredProducts = [];
  List<CategoryModel?> categories = [];
  List<Carousel> carousels = [];
  bool loadingCarousel = false;

  //
  fetchCategories()async{

    try{
      var result = await HttpService.getRequest(ApiConstants().categories);
      if(result is http.Response){
        if(result.statusCode == 200 || result.statusCode==201){
          categories = homeCategoriesModelFromJson(result.body)!.categories!;
          /*Future.delayed(const Duration(milliseconds: 100),(){
            sc.animateTo(
                -20,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate);
          });*/
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
        //autoScrollProducts();
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update();
  }

  //
  fetchFeaturedProducts({bool isRefresh = false,bool isLoadingNext = false}) async {

    update();
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
          for(int i=0;i<featuredProducts.length;i++){
            featuredProducts[i].color = await getImagePalette(featuredProducts[i].imgUrl!);
          }
        }
        //autoScrollProducts();
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    update();
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
    update();
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
    update();
  }

  //
  autoScrollProducts(){
    autoScrollTimer = Timer.periodic(
        const Duration(milliseconds: 3000), (timer) {
          if(productsSc.position.pixels==productsSc.position.maxScrollExtent){
            reverseScroll = true;
          }else if(productsSc.position.pixels==productsSc.position.minScrollExtent){
            reverseScroll = false;
          }
          if(reverseScroll){
            productsSc.animateTo(
                productsSc.position.pixels-172, duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          }else{
            productsSc.animateTo(
                productsSc.position.pixels+172, duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          }

    });

  }

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
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts(isRefresh: true);
    fetchFeaturedProducts();
    fetchCarousel1();
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