import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_nxt/Services/network_util.dart';
import 'package:grocery_nxt/Widgets/custom_button.dart';
import 'package:lottie/lottie.dart';

class InternetChecker extends StatefulWidget {
  InternetChecker({super.key, this.child, this.onRetry});

  Widget ?child;
  Function() ?onRetry;

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  @override
  Widget build(BuildContext context) {
    print(NetworkUtil.connectivityResult == ConnectivityResult.none);
    return !checkConnection()
        ? Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Lottie.asset('assets/animations/no_network.json'),

            SizedBox(height: 24.h),

            Text(
              "Check Your Interenet Connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),
            ),

            CustomButton(
              onTap: (){
                checkConnection();
                widget.onRetry!();
              },
              child: const Text("Retry",style: TextStyle(color: Colors.white),),
            )

          ],
        ),
      ),
    ):widget.child!;
  }

  bool checkConnection(){
    if(NetworkUtil.connectivityResult!=ConnectivityResult.none){
      setState(() {});
      return true;
    }
    return false;
  }
}
