import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../Constants/app_colors.dart';
import '../Controllers/chat_screen_controller.dart';
import 'dart:io';

class NormalChatBox extends StatefulWidget {
  NormalChatBox(
      {super.key,
      this.isCurrentUser,
      this.createdAt,
      this.message,
      this.isLastChat,
      this.showDate,
      this.index});

  bool? isCurrentUser;
  String? message;
  DateTime? createdAt;
  bool? isLastChat;
  bool? showDate;
  int? index;

  @override
  State<NormalChatBox> createState() => _NormalChatBoxState();
}

class _NormalChatBoxState extends State<NormalChatBox> {
  ChatScreenController vc = Get.find<ChatScreenController>(tag: "Chat Screen");

  @override
  Widget build(BuildContext context) {
    print("Building chat box");
    return Column(
      crossAxisAlignment: widget.isCurrentUser!
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [

        GestureDetector(
          onTap: (){
            if(widget.message!.contains("contact") && widget.isCurrentUser!)
             launchUrl(Uri.parse(url()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            margin: EdgeInsets.symmetric(
                vertical: 8.h,
                horizontal: 20.w),
            decoration: getDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7
                  ),
                  child: Text(
                    widget.message!,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp,
                        color: Colors.white),
                  ),
                ),

                SizedBox(width: 4.w),

                widget.message!.contains("contact") && widget.isCurrentUser!
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 4.h),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.call,
                          color: AppColors.primaryColor,
                          size: 16.sp,))
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ],
    );
  }

  //
  String url() {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/9003821040}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=9003821040}"; // new line
    }
  }

  //
  BoxDecoration getDecoration() {
    return widget.isCurrentUser!
        ? BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16.r))
        : BoxDecoration(
            color: const Color(0xff494949),
            borderRadius: BorderRadius.circular(16.r));
  }

  //
  Offset findWidgetPosition(BuildContext context, int index) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;

    Offset position =
        renderBox.localToGlobal(Offset(0, widget.showDate! ? 56.h : 8.h));

    print(position);

    return position;
  }
}


