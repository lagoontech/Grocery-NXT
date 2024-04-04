import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import '../Constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.child,
      this.isLoading = false,
      this.text,
      this.onTap,
      this.width,
      this.height});

  bool? isLoading;
  Widget? child;
  String? text;
  Function()? onTap;
  double? width;
  double ?height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30.r),
        child: InkWell(
          onTap: (){
            Future.delayed(const Duration(milliseconds: 300),(){
              onTap==null?(){}:onTap!();
            });
          },
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            width: width ?? MediaQuery.of(context).size.width * 0.5,
            height: height ?? 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                ),
            child: Container(
              child: isLoading!
                  ? CustomCircularLoader()
                  : child??Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
