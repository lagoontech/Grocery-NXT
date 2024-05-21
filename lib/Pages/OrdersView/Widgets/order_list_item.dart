import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/OrderDetailsView/order_details_view.dart';
import 'package:grocery_nxt/Pages/OrdersView/Controller/order_controller.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import '../Model/order_list_model.dart';

class OrderListItem extends StatelessWidget {
  OrderListItem({super.key, this.order});

  Order? order;
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
              child: order!.paymentStatus == "pending"
                  ? const Icon(Icons.pending, color: Colors.red)
                  : Icon(Icons.paid, color: AppColors.primaryColor),
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
                    "# ${order!.invoiceNumber}",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    order!.paymentGateway!.capitalizeFirst.toString(),
                    style: const TextStyle(color: Color(0xffb9b9b9)),
                  ),
                  order!.paymentMeta != null
                      ? Text(
                          "\u{20B9} ${order!.paymentMeta!.totalAmount!}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      : SizedBox()
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
                        () => OrderDetailsView(orderId: order!.id));
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
