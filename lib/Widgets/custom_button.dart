import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import '../Constants/app_colors.dart';
import '../Constants/app_size.dart';

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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;

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
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _colorController.addListener(() {
      setState(() {});
    });
    _colorAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ));
    _colorController.forward();
  }

  //
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
      child: DefaultTextStyle(
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
            letterSpacing: 0.72,
            fontSize: isIpad
                ? 12.sp
                : null
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                width: widget.width ?? MediaQuery.of(context).size.width * 0.5,
                height: widget.height ?? 40.h,
                decoration: BoxDecoration(
                  color: widget.color ?? AppColors.primaryColor.withOpacity(_colorAnimation.value),
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
                )
              ),
            );
          },
        ),
      ),
    );
  }

}
