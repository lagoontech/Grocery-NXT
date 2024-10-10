import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../Widgets/custom_appbar.dart';
import '../../../../Widgets/custom_textfield.dart';
import '../../../ChooseAddressView/Models/shipping_addresses_model.dart';
import 'Controller/view_address_controller.dart';

class ViewAddress extends StatelessWidget {
  ViewAddress({super.key,this.selectedAddress});

   ShippingAddress ?selectedAddress;

   ViewAddressController vc              = Get.put(ViewAddressController());

   TextEditingController searchTEC       = TextEditingController();
   TextEditingController stateSearchTEC  = TextEditingController();
   TextEditingController countryTEC      = TextEditingController();
   TextEditingController titleTEC        = TextEditingController();
   TextEditingController emailTEC        = TextEditingController();
   TextEditingController phoneTEC        = TextEditingController();
   TextEditingController addressTEC      = TextEditingController();
   TextEditingController zipcodeTEC      = TextEditingController();
   TextEditingController orderNoteTEC    = TextEditingController();
   TextEditingController stateTEC        = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setValues();
    return Scaffold(
      appBar: CustomAppBar(
        title: "Checkout Address",
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Address",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ],
                    ),
                    label("Title"),
                    customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Title",
                        controller: titleTEC,
                        readOnly: true,
                        onChanged: (v) {}),
                    label("Email"),
                    customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Email",
                        controller: emailTEC,
                        readOnly: true,
                        onChanged: (v) {}),
                    label("Phone"),
                    customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Enter a phone number",
                        textInputType: TextInputType.number,
                        controller: phoneTEC,
                        readOnly: true,
                        onChanged: (v) {}),
                    label("State"),
                    customTextField(context,
                        readOnly: true,
                        controller: stateTEC,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "State", onTap: () {
                          //showStatesBottomSheet(context);
                        }),
                    label("Address"),
                    customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Address",
                        readOnly: true,
                        controller: addressTEC,
                        onChanged: (v) {}),
                    label("Zipcode"),
                    customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        textInputType: TextInputType.number,
                        hint: "Zipcode",
                        readOnly: true,
                        controller: zipcodeTEC,
                        onChanged: (v) {
                          if(v!.length==6){
                            //getShippingCharge();
                          }
                        }),
                    SizedBox(height: 8.h),
                    label("Order Note"),
                    customTextField(context,
                        borderRadius: 12.r,
                        borderColor: const Color(0xffD7DFE9),
                        hint: "Order Note",
                        readOnly: true,
                        controller: orderNoteTEC,
                        onChanged: (v) {}),
                    SizedBox(
                      height: 32.h,
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),

    );
  }

  //


  //
  Widget label(String text) {

     return Padding(
       padding: EdgeInsets.symmetric(vertical: 16.h),
       child: Text(
           text,
           style: TextStyle(
               color: const Color(0xff2b3241).withOpacity(0.9),
               fontSize: 13.sp,
               fontWeight: FontWeight.w600)),
     );
   }

   //
  setValues(){
    
    titleTEC.text = selectedAddress!.name;
    emailTEC.text = selectedAddress!.email;
    phoneTEC.text = selectedAddress!.phone;
    stateTEC.text = selectedAddress!.state!.name;
    addressTEC.text = selectedAddress!.address!;
    zipcodeTEC.text = selectedAddress!.zipCode!;
  }

}
