import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomListView extends StatefulWidget {
  CustomListView({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollDirection = Axis.vertical,
    this.spacing=0,
    this.physics,
    this.padding,
    this.hasError = false,
    this.loading = false,
    this.internetError = false,
    this.emptyMessage='',
    this.loadingWidget,
    this.isGrid = false,
    this.crossAxisSpacing=0,
    this.childAspectRatio=0,
    this.mainAxisSpacing=0,
    this.mainAxisExtent,
    this.crossAxisCount=0,
    this.pixLoader = false
  }) : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();

  Widget Function(BuildContext,int index) itemBuilder;
  Axis scrollDirection;
  double spacing;
  int itemCount;
  ScrollPhysics ?physics;
  EdgeInsetsGeometry ?padding;
  bool hasError;
  bool loading;
  bool internetError;
  String emptyMessage;
  Widget ?loadingWidget;
  bool isGrid;
  double ?mainAxisExtent;
  double mainAxisSpacing;
  double crossAxisSpacing;
  double childAspectRatio;
  int crossAxisCount;
  bool pixLoader;
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    return
      widget.loading
          ? widget.loadingWidget ?? loadingWidget()
          : widget.internetError
          ? const Text('No network')
          : widget.hasError
          ? const Text('Server error')
          : widget.itemCount==0
          ? Center(child: Text(widget.emptyMessage))
          : !widget.isGrid
          ? ListView.separated(
          padding: widget.padding,
          scrollDirection: widget.scrollDirection,
          physics: widget.physics,
          shrinkWrap: true,
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
          separatorBuilder: (BuildContext context, int index) {
            return widget.scrollDirection == Axis.vertical
                ? SizedBox(height: widget.spacing)
                : SizedBox(width: widget.spacing);
          })
          : GridView.builder(
        scrollDirection: widget.scrollDirection,
        padding: widget.padding,
        shrinkWrap: true,
        physics: widget.physics,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            mainAxisExtent: widget.mainAxisExtent,
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
            childAspectRatio: widget.childAspectRatio
        ),
        itemBuilder: widget.itemBuilder,
        itemCount: widget.itemCount,
      );

  }


  Widget loadingWidget(){
    return Center(
        child: CircularProgressIndicator(strokeWidth: 4.sp)
    );
  }
}