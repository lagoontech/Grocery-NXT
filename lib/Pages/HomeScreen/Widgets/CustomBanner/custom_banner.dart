import 'package:flutter/material.dart';
import 'package:grocery_nxt/Pages/HomeScreen/Widgets/CustomBanner/wavy_sides_container.dart';

class CustomBanner extends StatelessWidget {
   CustomBanner({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.24,
      child: CustomPaint(
        painter: WavySidesContainer(),
      )
    );
  }
}
