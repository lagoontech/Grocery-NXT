import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customTextField(BuildContext context,
    {TextInputType? textInputType,
    Widget? prefix,
    String hint = "", String label = "",
    double? borderRadius=8,
    Color? borderColor,
    Color? fillColor,
    double? height,
    Widget? suffix,
    bool obscureText = false,
    bool readOnly = false,
    Color? color, Function() ?onTap,
    EdgeInsetsGeometry? contentPadding,
    TextCapitalization? textCapitalization,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    Function(String?)? onChanged,
      TextInputAction ?textInputAction,
    int? maxLength,
      int ?maxlines,

    }) {
  return TextFormField(
    onChanged: onChanged,
    onTap: onTap,
    readOnly: readOnly,
    keyboardAppearance: Brightness.dark,
    textInputAction: textInputAction ?? TextInputAction.done,
    obscureText: obscureText,
    maxLength: maxLength,
    maxLines: maxlines,
    inputFormatters: inputFormatters,
    controller: controller,
    validator: validator,
    autovalidateMode: AutovalidateMode.always,
    keyboardType: textInputType ?? TextInputType.text,
    style: TextStyle(fontSize: 12.sp, color: Colors.black),
    textCapitalization: textCapitalization ?? TextCapitalization.words,
    onSaved: onSaved,
    decoration: InputDecoration(
      label: Text(label),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      disabledBorder: InputBorder.none,
      //errorStyle: GoogleFonts.jost(),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.3)),
      isDense: true,
      filled: true,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 8.h,horizontal: 8.w),
      fillColor: fillColor ?? Colors.white.withOpacity(0.2),
      counterText: "",
      prefixIcon: prefix,
      suffixIcon: suffix,
      hintText: hint,
      hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400
      ),
      enabled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.sp),
        borderSide: BorderSide(
          width: 0.90,
          color: borderColor ?? Colors.transparent,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.sp),
        borderSide: BorderSide(
            color: borderColor ??
                Colors.transparent,
            width: 0.5
        ), // Set border color to transparent
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.sp),
        borderSide: BorderSide(
            color: borderColor ??
                Colors.transparent), // Set border color to transparent
      ),
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(borderRadius ?? 24.5.r),
      // ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.sp),
        borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 0.3), // Set border color to transparent
      ),
      // focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(borderRadius ?? 24.5.r),
      //     borderSide: const BorderSide(width: 0.5))
    ),
  );
}
