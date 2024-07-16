import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../../Constants/app_colors.dart';
import '../Controllers/chat_screen_controller.dart';

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

        Container(
          padding:
          EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          margin: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 20.w),
          decoration: getDecoration(),
          child: Text(
            widget.message!,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14.sp,
                color: Colors.white),
          ),
        ),
      ],
    );
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


