import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Controller/swiggy_view_controller.dart';
import 'package:grocery_nxt/Pages/SwiggyView/Models/sub_categories_model.dart';

import '../swiggy_view.dart';

class SubCategoryItem extends StatefulWidget {
   SubCategoryItem({super.key,this.subcategory});

   Subcategory ?subcategory;

  @override
  State<SubCategoryItem> createState() => _SubCategoryItemState();
}

class _SubCategoryItemState extends State<SubCategoryItem> {

  SwiggyViewController svc = Get.find<SwiggyViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: widget.subcategory!.positionKey,
      height: 100.h,
      child: GestureDetector(
        onTap: (){
          svc.selectedSubCategory = widget.subcategory;
          svc.fetchProducts(isRefresh: true);
          svc.findCategoryIndicatorOffset();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            GetBuilder<SwiggyViewController>(
              id: "${widget.subcategory!.id}",
              builder: (vc) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 50.w,
                  height: 56.h,
                  padding: EdgeInsets.only(top: 12.h),
                  decoration: BoxDecoration(
                    color:  Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6.r)),
                  ),
                  child: Transform.scale(
                    scale: vc.selectedSubCategory==widget.subcategory
                        ? 1.2:1,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.8,
                      child: CachedNetworkImage(
                          imageUrl: widget.subcategory!.imageUrl ?? "",
                          errorWidget: (c,e,o){
                            return Image.asset(
                              'assets/images/gnxt_logo.png',
                              width: MediaQuery.of(context).size.width*0.24,
                              color: AppColors.primaryColor,
                            );
                          },
                      ),
                    ),
                  ),
                );
              }
            ),

            SizedBox(height: 4.h),

            Expanded(
              child: Text(
                  widget.subcategory!.name!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600
                  ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
