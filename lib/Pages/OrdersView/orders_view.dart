import 'package:flutter/material.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Orders",),
    );
  }
}
