import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery_nxt/Constants/app_colors.dart';
import 'package:grocery_nxt/Pages/ChooseAddressView/Controller/choose_address_controller.dart';
import 'package:grocery_nxt/Pages/Payment%20Screen/Controller/payment_controller.dart';
import 'package:grocery_nxt/Widgets/custom_circular_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;


class RazorpayPayment extends StatefulWidget {
  RazorpayPayment({Key? key}) : super(key: key);

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {

  String? url;
  String? paymentID;
  WebViewController? _controller;

  PaymentController paymentController       = PaymentController();
  ChooseAddressController addressController = ChooseAddressController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Razorpay",),
      body: FutureBuilder(
          future: waitForIt(context),
          builder: (context,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: SizedBox(height: 60, child: CustomCircularLoader())),
                ],
              );
            }
            return WebViewWidget(controller: _controller!);

            /*WebViewWidget(
                onWebResourceError: (error) => showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text("Loading Failed"),
                        content: const Text("Failed to load payment page."),
                        actions: [
                          const Spacer(),
                          *//*TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentStatusView(true)),
                                    (Route<dynamic> route) => false),
                            child: Text(
                              'Return',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          )*//*
                        ],
                      );
                    }),
                onWebViewCreated: (controller) => _controller = controller,
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (value) async {
                  print('on finished.........................$value');
                  final uri = Uri.parse(value);
                  final response = await http.get(uri);
                  print(response.body.contains('PAID'));
                  bool paySuccess = response.body.contains('status":"paid');
                  print('closing payment......');
                  print('closing payment.............');
                  print('closing payment...................');
                  print('closing payment..........................');
                  *//*if (paySuccess) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => PaymentStatusView(false)),
                            (Route<dynamic> route) => false);
                    return;
                  }*//*
                }, controller: ,);*/
          }),
    );
  }

  //
  Future waitForIt(BuildContext context) async {

    final uri = Uri.parse('https://api.razorpay.com/v1/payment_links');
    // String username = "rzp_test_qfnlVh6GDZoveL";
    // String password = "1BKI89076hFeXRsbGuSaj29C";
    final username = paymentController.selectedOption!.credentials!.apiKey!; //selectedGateaway.credentials['api_key'];
    final password = paymentController.selectedOption!.credentials!.secretKey!; //selectedGateaway.credentials['api_secret'];
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    final orderId = paymentController.orderId;
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": 1,//cProvider.totalOrderAmount.round() * 100,
          "currency": "INR",
          "accept_partial": false,
          "reference_id": orderId.toString(),
          "description": "",//asProvider.getString('SafeCart Products'),
          "customer": {
            "name": "Anlin",
            "contact": "9080761312",
            "email": "anlin.jude.7@gmail.com"
          },
          // "notify": {"sms": true, "email": true},
          "notes": {"policy_name": "GroceryNxt"},
        }));
    print(response.body);
    if (response.statusCode == 200) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url!));
      url = jsonDecode(response.body)['short_url'];
      paymentID = jsonDecode(response.body)['id'];
      print(url);
      return;
    }
    //showToast(asProvider.getString('Connection failed'), cc.red);
    return 'failed';
  }

  //
  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('Payment Completed'));
    return response.body.contains('Payment Completed');
  }

}
