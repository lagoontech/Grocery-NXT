import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../Constants/app_colors.dart';
import '../Controllers/chat_screen_controller.dart';

Widget replyWidget() {
  ChatScreenController vc = Get.put(ChatScreenController(),tag: "Chat Screen");
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    onEnd: () {
      if (vc.replyChatIndex != null) {
        print(vc.scrollController.offset);
      }
    },
    height: vc.replyChatIndex != null ? 45.h : 0,
    margin: vc.replyChatIndex != null
        ? EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w)
        : EdgeInsets.zero,
    padding: EdgeInsets.only(right: 8.w),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: const Color(0xff494949),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: vc.replyChatIndex != null
        ? Row(
      children: [
        Container(
          color: AppColors.primaryColor,
          width: 4.w,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                vc.chats[vc.replyChatIndex!].name!,
                style: TextStyle(
                    color: AppColors.primaryColor, fontSize: 12.sp),
              ),
            ),
            Expanded(
                child: Text(
                  vc.chats[vc.replyChatIndex!].message!,
                  style: TextStyle(fontSize: 12.sp),
                )),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                onTap: () {
                  vc.replyChatIndex = null;
                  vc.update();
                },
                child:  Icon(Icons.close,size: 22.sp,)),
          ),
        )
      ],
    )
        : const SizedBox(),
  );
}