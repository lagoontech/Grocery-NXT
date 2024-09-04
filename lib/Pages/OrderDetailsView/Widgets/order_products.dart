import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Controller/order_details_controller.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/Model/order_details_model.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';

class OrderProducts extends StatelessWidget {
   OrderProducts({super.key,this.details});

   OrderDetailsModel ?details;

   OrderDetailsController vc = Get.find<OrderDetailsController>();
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

                    TextButton(
                      onPressed: () {
                        showRatingDialog(context,product!.product!);
                      },
                      child: Text("Rate")),

                    Divider()

                  ],
                );
              }
          ),
        ],
      ),
    );
  }

  //
  showRatingDialog(BuildContext context,Product product) async {

    double _rating = 0.0;
    TextEditingController _reviewController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate and Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RatingBar(
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border_sharp,
                onRatingChanged: (v ) {
                  _rating = v;
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  labelText: 'Write your review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            GetBuilder<OrderDetailsController>(
              builder: (vc) {
                return !vc.isRating?ElevatedButton(
                  onPressed: () {
                    if (_rating > 0 && _reviewController.text.isNotEmpty) {
                      // Handle the submission of the rating and review
                      vc.rateProduct(product,rating: _rating.ceilToDouble().toInt(),ratingMessage: _reviewController.text);
                    } else {
                      // Show a message that rating and review are required
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Rating and review are required'),
                        ),
                      );
                    }
                  },
                  child: Text('OK'),
                ): CustomCircularLoader();
              }
            ),
          ],
        );
      },
    );
  }

}
