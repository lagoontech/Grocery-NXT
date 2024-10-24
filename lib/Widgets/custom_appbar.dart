import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    this.title,
    this.action,
    this.color,
    this.elevation,
    this.textColor,
    TabBar ?bottom});

  String ?title = "";
  Widget ?action;
  Color  ?color;
  double ?elevation;
  Color  ?textColor;

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: color ?? Colors.white,
      scrolledUnderElevation: 0,
      title: Text(
        title!,
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black,
            letterSpacing: 0.75
        ),
      ),
      centerTitle: true,
      elevation: elevation ?? 0,
      actions: [action ?? const SizedBox()],
    );

  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
