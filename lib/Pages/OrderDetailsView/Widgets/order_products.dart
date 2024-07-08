import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Model/order_details_model.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';

class OrderProducts extends StatelessWidget {
   OrderProducts({super.key,this.details});

   OrderDetailsModel ?details;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "All Products",
      ),
      body: Column(
        children: [

          SizedBox(height: 24.h),

          ListView.builder(
              shrinkWrap: true,
              itemCount: details!.order![0].orderItem!.length,
              itemBuilder: (context,index){
                var product = details!.order![0].orderItem![index];
                return Column(
                  children: [

                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: product.product!.image!,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(
                          product.product!.name!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13.sp
                          ),
                      ),
                      trailing: product.price!=null?Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          DefaultTextStyle(
                            style: TextStyle(color: Colors.grey.shade500,fontSize: 12.sp),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(product.quantity.toString()+" * "),
                                Text(double.parse(product.price!).toStringAsFixed(0)!),
                              ],
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text("\u{20B9}"+(product.quantity!*double.parse(product.price.toString())).toStringAsFixed(0))

                        ],
                      ):SizedBox(),
                    ),

                    Divider()

                  ],
                );
              }
          ),
        ],
      ),
    );
  }
}
