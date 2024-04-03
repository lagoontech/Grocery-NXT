import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Controller/choose_address_controller.dart';
import 'package:grocery_nxt/Widgets/custom_appbar.dart';

class ChooseAddressView extends StatelessWidget {
   ChooseAddressView({super.key});

   ChooseAddressController vc = Get.put(ChooseAddressController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: "Choose Address",
      ),
      body: Column(
        children: [



        ],
      ),
    );
  }
}
