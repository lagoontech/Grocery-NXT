import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/api_constants.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import '../Models/home_categories_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController{

  ScrollController sc = ScrollController();
  int bottomIndex = 0;
  double categoryScrollProgress = 0.0;
  double currentCategoryScrollProgress = 0.0;


  List<CategoryModel?> categories = [];

  //
  fetchCategories()async{

    try{
      var result = await HttpService.getRequest(ApiConstants().categories);
      if(result is http.Response){
        if(result.statusCode == 200 || result.statusCode==201){
          categories = homeCategoriesModelFromJson(result.body)!.categories!;
          Future.delayed(const Duration(milliseconds: 100),(){
            sc.animateTo(
                -20,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate);
          });
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
  calculateCurrentScrollPosition(){

    final maxScrollExtent = sc.position.maxScrollExtent;
    final currentScrollOffset = sc.position.pixels;
    categoryScrollProgress = currentCategoryScrollProgress;
    if(!currentScrollOffset.isNegative) {
      currentCategoryScrollProgress = (currentScrollOffset / maxScrollExtent);
    }
    update(["scrollIndicator"]);
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    sc.addListener(() {
      calculateCurrentScrollPosition();
      update();
    });
  }

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }

}