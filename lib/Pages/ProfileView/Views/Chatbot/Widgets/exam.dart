// DraggableScrollableSheet
// (
// controller: draggableScrollableController,
// initialChildSize: 0.5,
// maxChildSize: 0.9,
// builder: (BuildContext context, ScrollController scrollController) {
// return LayoutBuilder(builder: (context, movable) {
// print("movable:$movable");
// return AnimatedPadding(
// curve: Curves.easeInOutQuad,
// padding: EdgeInsets.only(
// bottom: MediaQuery.of(context).viewInsets.bottom),
// duration: const Duration(milliseconds: 500),
// child: Container(
// decoration: BoxDecoration(
// color: AppColors().bgColor,
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(30.r),
// topRight: Radius.circular(30.r))),
// child: Stack(
// children: [
// Padding(
// padding: EdgeInsets.only(top: 60.h),
// child: ListView.builder(
// controller: scrollController,
// itemCount: content.length,
// itemBuilder: (BuildContext context, int index) {
// return Column(
// children: [
// kHSizedBox15,
// chatInvite(context,
// name: 'Mac_man',
// asset: 'assets/images/animoji (2).png',
// teamName: 'TEAM X',
// level: 'Level 1',
// color: 'black'),
// ],
// );
// },
// ),
// ),
// Padding(
// padding: EdgeInsets.only(top: 15.h),
// child: Container(
// child: Padding(
// padding: EdgeInsets.symmetric(horizontal: 15.h),
// child: CustomSearchField(),
// ),
// ),
// )
// ],
// ),
// ));
// });
// },
// )