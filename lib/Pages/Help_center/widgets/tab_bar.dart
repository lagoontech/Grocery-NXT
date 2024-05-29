import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Constants/size.dart';

import '../../../../Widgets/custom_appbar.dart';

class TabBarD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: CustomAppBar(
          title: 'Help Center',
          bottom: TabBar(
            //padding:EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top-10),
            tabs: const [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Home')),
            Center(child: Text('Settings')),
          ],
        ),
      ),
    );
  }
}
