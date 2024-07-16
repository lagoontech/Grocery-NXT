import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/chat_section.dart';

class ChatScreenController extends GetxController{

  ScrollController scrollController = ScrollController();
  TextEditingController chatTEC     = TextEditingController();

  FocusNode focusNode = FocusNode();

  RxBool   hasFocus = false.obs;
  RxDouble height   = 0.0.obs;
  int ?replyChatIndex;

  BuildContext ?context;

  List<ChatModel> chats = [
    ChatModel(userId: 1,message: "Hello there",createdAt: DateTime.now().subtract(const Duration(days: 1))),
  ];

  //
  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(() {
      if(focusNode.hasFocus){
        hasFocus.value = true;
        Future.delayed(const Duration(milliseconds: 500),(){
          scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        });
      }else{
        hasFocus.value = false;
      }
    });
  }

  //
  onUserChat(String chat) {

    chats.add(ChatModel(
      userId: 2,
      message: chat,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ));
    update();
    int index = keys.indexWhere(
        (element) => element.toLowerCase().contains(chat.toLowerCase()));
    if (index != -1) {
      chats.add(ChatModel(
        userId: 1,
        message: responses[index],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ));
      update();
      chatTEC.text = "";
    }
  }

  //
  onRightSwipe(int index){
    print(index);
    replyChatIndex = index;
    update();
  }

  List<String> keys = [
    "What is AAvana RAvana?",
    "Who founded AAvana RAvana?",
    "When was AAvana RAvana founded?",
    "Where was AAvana RAvana founded?",
    "How did AAvana RAvana start?",
    "Who established the shop in Melamada Veethi?",
    "What is the motto of AAvana RAvana?",
    "What makes AAvana RAvana unique?",
    "How long have AAvana RAvana's customers been with them?",
    "How does AAvana RAvana ensure quality?",
    "What products does AAvana RAvana supply?",
    "Who are the main customers of AAvana RAvana?",
    "What is GroceryNext (GNXT)?",
    "What can you find on GroceryNext?",
    "What are the store hours?",
    "How can I contact AAvana RAvana?",
    "How can I download the GroceryNext app?",
    "What is the privacy policy?",
    "What are the terms and conditions?",
    "What is the cookie policy?",
    "Do you offer delivery?",
    "What are the delivery charges?",
    "Do you have daily discounts?",
    "What are the available grocery categories?",
    "What types of rice are available?",
    "What beauty and health products are available?",
    "What cleaning products are available?",
    "How can I place an order?",
    "What payment methods are accepted?",
    "Can I return a product?",
    "How do I track my order?",
    "Can I modify my order?",
    "What if my order is delayed?",
    "Do you offer customer support?",
    "How can I provide feedback?",
    "Do you have a loyalty program?",
    "Are there any ongoing promotions?",
    "Can I schedule a delivery?",
    "Is there a minimum order amount?",
    "What is the return policy?",
    "How do I create an account?",
    "How can I reset my password?",
    "How do I update my account information?",
    "What if I forget my password?",
    "How do I apply a discount code?",
    "Can I cancel my order?",
    "What happens if a product is out of stock?",
    "Do you offer gift cards?",
    "How do I redeem a gift card?",
    "What are your best-selling products?"
  ];

  List<String> responses = [
    "AAvana RAvana, also known as AARA, is a well-established store founded by Ramasamy Pillai in 1930 in Tirunelveli Pettai, known for its quality products.",
    "AAvana RAvana was founded by Ramasamy Pillai.",
    "AAvana RAvana was founded in the year 1930.",
    "AAvana RAvana was founded in Tirunelveli Pettai.",
    "AAvana RAvana started with Ramasamy Pillai marketing the store using a bicycle, then moving to the TOWN area.",
    "Selvarathinam, the son of Ramasamy Pillai, established a shop in Melamada Veethi in 1960.",
    "Our motto is “QUALITY SPEAKS”.",
    "We are unique due to our commitment to providing only first-quality products.",
    "We have had customers for more than 60 years.",
    "We manually test our products at home before offering them to our customers.",
    "We supply supermarkets, catering, hotels, events, and other E-Commerce sites, with a focus on marriage events.",
    "Our main customers include supermarkets, catering services, hotels, events, and more.",
    "GroceryNext (GNXT) is our new website to serve customers all over the cities.",
    "On GroceryNext, you can get quality and healthy products for your family.",
    "Our store hours are from 9:00 to 21:00.",
    "You can contact us at 9003821040.",
    "You can download the GroceryNext app from our website.",
    "You can view our privacy policy on our website.",
    "You can view our terms and conditions on our website.",
    "You can view our cookie policy on our website.",
    "Yes, we offer delivery services across India.",
    "Delivery charges apply for wholesale prices.",
    "Yes, we offer daily mega discounts.",
    "Available grocery categories include Atta & Flours, Beverages, Dals, Dry Fruits & Nuts, and more.",
    "We offer Rice, Traditional Rice, and Millets.",
    "Available beauty and health products include Bath & Hygiene, Cosmetics, and Face Care.",
    "Available cleaning products include Dishwashers, Disinfectants, Floor Cleaners, and Fresheners & Repellents.",
    "You can place an order through our website or app.",
    "We accept various payment methods including credit cards, debit cards, and digital wallets.",
    "Yes, you can return a product within our return policy period.",
    "You can track your order through our website or app.",
    "You can modify your order before it is shipped.",
    "If your order is delayed, please contact our customer support for assistance.",
    "Yes, we offer customer support through our website and app.",
    "You can provide feedback through our website or app.",
    "Yes, we have a loyalty program for our customers.",
    "You can view ongoing promotions on our website or app.",
    "Yes, you can schedule a delivery at your convenience.",
    "There is no minimum order amount.",
    "You can view our return policy on our website.",
    "You can create an account through our website or app.",
    "You can reset your password through the 'Forgot Password' option on our website or app.",
    "You can update your account information through your account settings.",
    "If you forget your password, you can reset it through the 'Forgot Password' option.",
    "You can apply a discount code at checkout.",
    "Yes, you can cancel your order before it is shipped.",
    "If a product is out of stock, we will notify you and offer alternatives.",
    "Yes, we offer gift cards.",
    "You can redeem a gift card during checkout.",
    "Our best-selling products include various categories of groceries, beauty and health products, and cleaning supplies."
  ];

}