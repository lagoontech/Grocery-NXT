import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class ProfileItem extends StatelessWidget {
   ProfileItem({super.key,this.title="",this.iconAsset="",this.onTap});

   String title;
   String iconAsset;
   Function() ?onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Future.delayed(const Duration(milliseconds: 300),(){
          onTap!();
        });
      },
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.05),
                shape: BoxShape.circle
              ),
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SvgPicture.asset(
                      "assets/icons/$iconAsset.svg",
                      color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(left: 24.w),
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp
                ),
              ),
            ),
            trailing: Image.asset(
              "assets/icons/arrow_forward.png",
              width: 12.w,
              height: 12.h,),
          ),

          Divider(
              height: 0,
              color: Colors.grey.shade200,
              thickness: 0.6)
        ],
      ),
    );
  }
}
