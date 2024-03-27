import 'package:flutter/material.dart';

class CustomCircularLoader extends StatelessWidget {

   CustomCircularLoader({
     super.key,
     this.color,
     this.height,
     this.width
   });

   double ?width;
   double ?height;
   Color? color;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: width ?? 20,
        height:  height ?? 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: color ?? Colors.white,
        )
    );
  }
}
