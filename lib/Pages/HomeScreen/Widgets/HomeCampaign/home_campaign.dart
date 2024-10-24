import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Controller/home_controller.dart';
import 'package:slide_countdown/slide_countdown.dart';

class HomeCampaign extends StatelessWidget {
  HomeCampaign({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (vc) {
        return homeController.campaign != null
            ? SizedBox(
              height: MediaQuery.of(context).size.height*0.26,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeController.campaign!.data!.length,
                  itemBuilder: (context, index) {
                    var campaign = homeController.campaign!.data![index];
                    return Stack(
                      children: [

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.20,
                          child: FittedBox(
                              child: CachedNetworkImage(
                                  imageUrl: campaign!.image!,
                                  fit: BoxFit.fitHeight)),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height*0.20,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom: 4.h),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.05),
                                    Colors.black.withOpacity(0.3)
                                  ]
                              )
                          ),
                          alignment: Alignment.bottomCenter,
                          child: FittedBox(
                              child: SlideCountdownSeparated(
                                showZeroValue: true,
                                separator: '',
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                duration: campaign.endDate != null &&
                                    campaign.endDate!
                                        .isAfter(DateTime.now())
                                    ? campaign.endDate!
                                    .difference(DateTime.now())
                                    : const Duration(seconds: 1),
                              )),
                        ),


                      ],
                    );
                  }),
            )
            : const SizedBox();
      }
    );
  }
}
