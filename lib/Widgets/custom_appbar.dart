import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
   CustomAppBar({
     super.key,
     this.title,
     this.action
   });

   String ?title = "";
   Widget ?action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      title: Text(title!,style: TextStyle(fontSize: 16),),
      actions: [
        action??SizedBox()
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
