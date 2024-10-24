import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  String selectedChip = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              customChip(
                'All',
                isSelected: selectedChip == 'All',
                onSelected: (chipText) =>
                    setState(() => selectedChip = chipText),
              ),
              customChip(
                'Service',
                isSelected: selectedChip == 'Service',
                onSelected: (chipText) =>
                    setState(() => selectedChip = chipText),
              ),
              customChip(
                'Payment',
                isSelected: selectedChip == 'Payment',
                onSelected: (chipText) =>
                    setState(() => selectedChip = chipText),
              ),
              customChip(
                'Account',
                isSelected: selectedChip == 'Account',
                onSelected: (chipText) =>
                    setState(() => selectedChip = chipText),
              ),
            ],
          ),
        ),
        CustomExpansionTile(
          title: 'Can I track my order’s delivery status?',
          content: 'Lorem ipsum Reference site aboutLoremIpsum, '
              'giving information on its origins, '
              'as well as a random Lipsum generator.',
        ),
      ],
    );
  }

  Widget customChip(String? chip,
      {bool isSelected = false, Function(String)? onSelected}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: ChoiceChip(
        side: const BorderSide(color: Colors.transparent),
        selected: isSelected,
        elevation: 0.3,
        selectedColor: AppColors.primaryColor,
        onSelected: (v) {
          if (onSelected != null) {
            onSelected(chip!);
          }
        },
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
        label: Text(
          chip ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.r))),
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String ?content;
  final Widget? leading;
  final Widget? trailing;
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;

  const CustomExpansionTile({
    required this.title,
    this.content,
    this.leading,
    this.trailing,
    this.itemCount,
    this.itemBuilder,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.2),
            borderRadius: BorderRadius.circular(10.r)),
        child: Theme(
          data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              widget.title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            children: [
              const Divider(
                endIndent: 17,
                indent: 17,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.r,  bottom: 8.r),
                child: Text(
                  widget.content??'',
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
