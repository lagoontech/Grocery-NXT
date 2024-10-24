import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Constants/app_colors.dart';
import '../../../../Widgets/custom_appbar.dart';
import 'Controllers/chat_screen_controller.dart';
import 'Widgets/chat_section.dart';
import 'Widgets/replyWidget.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isHidetextfield = true;
  bool isHideAccept = true;
  bool _iscontainervisible = false;

  ChatScreenController vc = Get.put(ChatScreenController());

  @override
  void initState() {
    super.initState();
    vc.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "GNxt Assistant"),
      resizeToAvoidBottomInset: true,
      body: GetBuilder<ChatScreenController>(
        builder: (vc) {
          return Stack(
            children: [

              Image.asset(
                "assets/images/grocery.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fitWidth,
                color: Colors.black.withOpacity(0.02),
              ),

              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                decoration: BoxDecoration(

                ),
                child: Column(
                  children: [
                    ChatSection(onAccepted: (v) {
                      setState(() {
                        isHidetextfield = v;
                      });
                    }),
                    GetBuilder<ChatScreenController>(
                        builder: (vc) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8.h, left: 6.w, right: 6.w,top: 4.h),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                replyWidget(),
                                 TextFormField(
                                  focusNode: vc.focusNode,
                                  controller: vc.chatTEC,
                                  onFieldSubmitted: (v){
                                    vc.onUserChat(v);
                                    vc.focusNode.unfocus();

                                  },
                                   onEditingComplete: (){
                                   },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.primaryColor,
                                      isDense: true,
                                      hintText: "Enter your query...",
                                      hintStyle: const TextStyle(
                                          color: Colors.white),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                          BorderRadius.circular(30.r)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                          BorderRadius.circular(30.r)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                          BorderRadius.circular(30.r))),
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

