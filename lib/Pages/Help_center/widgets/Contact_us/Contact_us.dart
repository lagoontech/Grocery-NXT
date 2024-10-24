import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactusView extends StatefulWidget {
  const ContactusView({super.key});

  @override
  State<ContactusView> createState() => _ContactusViewState();
}

class _ContactusViewState extends State<ContactusView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: ListView(
      children: [
        Column(
          children: [
            customListTile(
              context,
              title: "Customer Service",
              leading: "assets/icons/headPhone.svg",
            ),
            customListTile(
              context,
              title: "Whatsapp",
              leading: "assets/icons/WhatsApp.svg",
              content: "9626818076"),
          ],
        )
      ],
    ));
  }

  Widget customListTile(BuildContext context,
      {String? title, String? leading, Widget? trailing, Color?color,String? content}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent),
            child: ExpansionTile(
              title: Center(
                child: Text(
                  title ?? '',
                  style:
                      TextStyle(fontWeight: FontWeight.w800, fontSize: 15.sp),
                ),
              ),
              leading: SvgPicture.asset(leading ?? '',color: color,),
              children: content != null
                  ? [
                      Container(
                        color: Colors.grey.shade200,
                        child: IntrinsicWidth(
                            child: Padding(
                          padding: EdgeInsets.all(2.r),
                          child: Text(content),
                        )),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                    ]
                  : [
                      SizedBox(
                        height: 5.h, // Adjust height as needed
                      ),
                    ],
            ),
          )),
    );
  }
}
