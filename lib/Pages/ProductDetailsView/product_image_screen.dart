import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ProductImageScreen extends StatelessWidget {
   ProductImageScreen({super.key,this.imgUrl});

   String ?imgUrl;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: imgUrl,
        color: AppColors.primaryColor,
      ),
      body: Center(
        child: WidgetZoom(// optional VoidCallback
          zoomWidget: CachedNetworkImage(
            imageUrl: imgUrl!,
            fit: BoxFit.contain,
          ), heroAnimationTag: "",
        ),
      )
    );
  }
}
