import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Controllers/chat_screen_controller.dart';
import 'normal_chat_box.dart';

class ChatSection extends StatefulWidget {
  ChatSection({super.key, this.onAccepted, this.onHideAccept});

  Function(bool)? onAccepted;
  Function(bool)? onHideAccept;

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  int userId = 1;

  ChatScreenController vc = Get.find<ChatScreenController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: ListView.builder(
          controller: vc.scrollController,
          reverse: true,
          padding: EdgeInsets.only(top: 10.h),
          itemCount: vc.chats.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var chat = vc.chats[index];
            return NormalChatBox(
              index: index,
              key: chat.key,
              isCurrentUser: chat.userId == 1,
              message: chat.message,
              createdAt: chat.createdAt,
            );
          }),
    );
  }

  bool areDatesEqual(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class ChatModel {
  String? name;
  int? userId;
  String? message;
  DateTime? createdAt;
  bool ?isSupport;

  // GlobalKey? key;
  final GlobalKey key;

  ChatModel({this.name = "Vedh", this.message, this.userId, this.createdAt,this.isSupport})
      : key = GlobalKey();
}
