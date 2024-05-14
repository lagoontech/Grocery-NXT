import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ProductImageScreen extends StatelessWidget {
   ProductImageScreen({super.key,this.imgUrl});

   String ?imgUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: imgUrl,
        color: AppColors.primaryColor,
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Zoom(
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
            child: CachedNetworkImage(
              imageUrl: imgUrl!,
              fit: BoxFit.fill,
            )
        ),
      ),
    );
  }
}
