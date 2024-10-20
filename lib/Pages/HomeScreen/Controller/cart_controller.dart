import 'dart:convert';
import 'dart:developer';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Services/http_services.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:grocery_nxt/Utils/toast_util.dart';
import '../../AllProductsView/Model/products_list_model.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {

  GlobalKey<CartIconKey> cartIconKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  ScrollController scrollController = ScrollController();

  List<Product> products = [];
  double totalCost       = 0.0;
  double subTotal        = 0.0;
  double total           = 0.0;
  double couponAmount    = 0.0;
  int totalProducts      = 0;
  TextEditingController couponController = TextEditingController();
  bool applyingCoupon    = false;

  //
  addToCartFromDetailsPage({Product? product}) {

    if (product!.variantInfo != null && product.itemType == null) {
      int index = products.indexWhere((element) {
        if (element.productColor != null) {
          return element.variantInfo!.pidId == product.variantInfo!.pidId
              && element.productColor!.name == product.productColor!.name
              && element.productColor!.id == product.productColor!.id;
        }
        return false;
      });
      if (index != -1) {
        products[index].cartQuantity = product.cartQuantity;
      } else {
        products.add(Product.fromJson(product.toJson()));
      }
    } else if (product.variantInfo != null && product.itemType != null) {
      int index = products.indexWhere((element) {
        if (element.productColor != null && element.itemType != null) {
          return element.variantInfo!.pidId == element.variantInfo!.pidId &&
              element.itemType!.id == product.itemType!.id && element.productColor!.name == product.productColor!.name;
        }
        return false;
      });
      if (index != -1) {
        products[index].cartQuantity = product.cartQuantity;
      } else {
        products.add(Product.fromJson(product.toJson()));
      }
    } else {
      int index = products.indexWhere((element) =>
          (element.prdId == product.prdId && element.variantInfo == null));
      if (index != -1) {
        products[index].cartQuantity = product.cartQuantity;
      } else {
        products.add(Product.fromJson(product.toJson()));
      }
    }
    SharedPrefUtils.pref!.setStringList(
        "products",
        products.map((e) {
          return jsonEncode(e.toJson());
        }).toList());
    calculateTotalProducts();
    calculateTotal();
    update();
    ToastUtil().showToast(message: "Added to cart", color: AppColors.primaryColor);
    calculateWeight();

  }

  //
  calculateWeight(){

    weight = 0.0;
    for (var element in products) {
      if(element.productColor!=null){
        switch (element.productColor!.sizeCode!.toLowerCase()) {
          case 'gm':
            weight += element.cartQuantity * element.productColor!.weight! * 0.001;
          case 'kg':
            weight += element.productColor!.weight! * element.cartQuantity;
          case 'litre':
            weight += element.productColor!.weight! * element.cartQuantity;
          case 'liter':
            weight += element.productColor!.weight! * element.cartQuantity;
          case 'ml':
            weight += element.cartQuantity * element.productColor!.weight! * 0.001;
          default:
        }
      }else if(element.uom!=null){
        switch (element.uom!.unit!.name!.toLowerCase()) {
          case 'gm':
            weight += element.cartQuantity * element.uom!.quantity! * 0.001;
          case 'kg':
            weight += element.uom!.quantity! * element.cartQuantity;
          case 'litre':
            weight += element.uom!.quantity! * element.cartQuantity;
          case 'liter':
            weight += element.uom!.quantity! * element.cartQuantity;
            case 'ml':
            weight +=  element.cartQuantity * element.uom!.quantity! * 0.001;
          default:
        }
      }
    }

  }

  double weight = 0.0;

  //
  addToCart(
      {Product? product,
      bool isSub = false,
      bool showToast = true,
      bool isVariant = false}) {
    if (product!.variantInfo != null && product.itemType == null) {
      int index = products.indexWhere((element) {
        if (element.productColor != null) {
          return element.prdId == product.prdId &&
              element.productColor!.id == product.productColor!.id;
        }
        return false;
      });
      if (isSub) {
        products[index].cartQuantity = products[index].cartQuantity - 1;
        if (products[index].cartQuantity == 0) {
          products.removeAt(index);
        }
      } else {
        if (index != -1) {
          products[index].cartQuantity = products[index].cartQuantity + 1;
        } else {
          products.add(product..cartQuantity = 1);
        }
      }
      SharedPrefUtils.pref!.setStringList(
          "products",
          products.map((e) {
            return jsonEncode(e.toJson());
          }).toList());
      calculateTotal();
      calculateTotalProducts();
      update();
      return;
    } else if (product.variantInfo != null && product.itemType != null) {
      int index = products.indexWhere((element) {
        if (element.productColor != null && element.itemType != null) {
          return element.prdId == product.prdId &&
              element.productColor!.id == product.productColor!.id &&
              element.itemType!.id == product.itemType!.id;
        }
        return false;
      });
      if (isSub) {
        products[index].cartQuantity = products[index].cartQuantity - 1;
        if (products[index].cartQuantity == 0) {
          products.removeAt(index);
        }
      } else {
        if (index != -1) {
          products[index].cartQuantity = products[index].cartQuantity + 1;
        } else {
          products.add(product..cartQuantity = 1);
        }
      }
      SharedPrefUtils.pref!.setStringList(
          "products",
          products.map((e) {
            return jsonEncode(e.toJson());
          }).toList());
      calculateTotal();
      calculateTotalProducts();
      update();
      return;
    }
    bool hasProduct = products
            .firstWhere(
                (element) =>
                    element.prdId == product.prdId &&
                    element.variantInfo == null,
                orElse: () => Product(prdId: null))
            .prdId !=
        null;
    int index = products.indexWhere((element) =>
        element.prdId == product.prdId && element.variantInfo == null);
    if (isSub) {
      if (hasProduct) {
        products[index].cartQuantity = products[index].cartQuantity - 1;
        if (products[index].cartQuantity == 0) {
          products.removeAt(index);
        }
      }
      update();
      SharedPrefUtils.pref!.setStringList(
          "products",
          products.map((e) {
            return jsonEncode(e.toJson());
          }).toList());
      calculateTotal();
      calculateTotalProducts();
      return;
    }
    if (hasProduct) {
      products[index].cartQuantity = products[index].cartQuantity + 1;
    } else {
      products.add(product..cartQuantity = 1);
      products.forEach((element) {
        print(product.discountPrice);
      });
    }
    SharedPrefUtils.pref!.setStringList(
        "products",
        products.map((e) {
          return jsonEncode(e.toJson());
        }).toList());
    calculateTotal();
    calculateTotalProducts();
    update();
  }

  //
  bool hasProduct(Product product) {
    return products
            .firstWhere((element) => element.prdId == product.prdId,
                orElse: () => Product(prdId: null))
            .prdId !=
        null;
  }

  //
  calculateTotal() {
    calculateSubTotal();
    total = subTotal - couponAmount;
  }

  //
  calculateTotalProducts() {
    totalProducts = 0;
    for (var element in products) {
      totalProducts = totalProducts + element.cartQuantity;
    }
  }

  //
  loadProducts() {
    products.clear();
    if (SharedPrefUtils.pref!.containsKey("products")) {
      for (var element in SharedPrefUtils.pref!.getStringList("products")!) {
        products.add(Product.fromJson(jsonDecode(element)));
      }
    }
    calculateTotalProducts();
    calculateTotal();
    update();
  }

  //
  calculateSubTotal() {
    subTotal = 0.0;
    for (var element in products) {
      subTotal += (element.cartQuantity) * (element.discountPrice);
    }
  }

  //
  Future<void> applyCoupon() async {
    if (couponController.text.isEmpty) {
      return;
    }
    calculateSubTotal();
    applyingCoupon = true;
    update(["coupon"]);
    try {
      var result = await HttpService.postRequest("apply-coupon", {
        "product_ids": products.map((e) => e.prdId).toList(),
        "coupon": couponController.text,
        "subTotal": subTotal
      });
      if (result is http.Response) {
        if (result.statusCode == 200) {
          if (jsonDecode(result.body)["type"] == "error") {
            ToastUtil().showToast(
                message: jsonDecode(result.body)["msg"],
                color: AppColors.primaryColor);
            applyingCoupon = false;
            update(["coupon"]);
            update();
            return;
          }
          couponAmount = double.parse(jsonDecode(result.body)["coupon_amount"]);
          calculateTotal();
          ToastUtil().showToast(
              message: "Coupon Applied!", color: AppColors.primaryColor);
        } else {}
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    applyingCoupon = false;
    update(["coupon"]);
    update();
  }

  //
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }
}
