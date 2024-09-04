import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import '../Constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    Key? key,
    this.child,
    this.isLoading = false,
    this.text,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
  }) : super(key: key);

  final bool isLoading;
  final Widget? child;
  final String? text;
  final Function()? onTap;
  final double? width;
  final double? height;
  Color ?color;
  double ?borderRadius;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _controller.forward().then((value){
          _controller.reverse().then((value){
            widget.onTap!();
          });
        });
      },
      /*onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapCancel: () {
        _controller.reverse();
      },*/
      child: DefaultTextStyle(
        style: TextStyle(fontWeight: FontWeight.w600,fontFamily: GoogleFonts.ibmPlexSans().fontFamily),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Container(
                width: widget.width ?? MediaQuery.of(context).size.width * 0.5,
                height: widget.height ?? 40.h,
                decoration: BoxDecoration(
                  color: widget.color ?? AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius ??  30.r),
                ),
                child: Center(
                  child: widget.isLoading
                      ? CustomCircularLoader()
                      : widget.child ??
                      Text(
                        widget.text!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
