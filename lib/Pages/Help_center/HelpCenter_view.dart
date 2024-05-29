import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_nxt/Pages/Help_center/widgets/Contact_us/Contact_us.dart';
import 'package:grocery_nxt/Pages/Help_center/widgets/Faq/FAq_screen.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
       //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Help Center',
        ),
        body: Column(
          children: [

            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              dividerHeight: 0,
              tabs: [
                Tab(
                  child: Text(
                    'FAQ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                 child: Text(
                    'Contact Us',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Expanded(
              child: TabBarView(
                  children: [
                    FAQScreen(),
                    ContactusView(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
