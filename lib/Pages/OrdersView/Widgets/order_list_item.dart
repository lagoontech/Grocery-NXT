import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/order_details_view.dart';
import 'package:grocery_nxt/Pages/OrdersView/Controller/order_controller.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import '../Model/order_list_model.dart';

class OrderListItem extends StatelessWidget {
  OrderListItem({super.key, this.order, this.index});

  SubordersDatum? order;
  int? index;
  OrderController vc = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 88.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 85.w,
              height: 85.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: order!.orderItem!.length > 1
                  ? GridView.builder(
                      itemCount: order!.orderItem!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        var image = order!.orderItem![index].product!.image;
                        return CachedNetworkImage(
                            imageUrl:
                                "https://grocerynxt.ltcloud247.com/assets/uploads/media-uploader/${image!.path}");
                      })
                  : CachedNetworkImage(
                      imageUrl:
                          "https://grocerynxt.ltcloud247.com/assets/uploads/media-uploader/${order!.orderItem![0].product!.image!.path}"),
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "# ${order!.order!.invoiceNumber!.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  order!.order!.paymentMeta != null
                      ? Text(
                          "\u{20B9} ${order!.order!.paymentMeta!.totalAmount!}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: CustomButton(
                  width: 80.w,
                  height: 24.h,
                  onTap: () async {
                    var result = await Get.to(
                        () => OrderDetailsView(orderId: order!.orderId));
                    if (result == 1) {
                      vc.getOrders();
                    }
                  },
                  child: const Text(
                    "Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
