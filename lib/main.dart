import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Pages/SplashScreen/splash_screen.dart';
import 'package:grocery_nxt/Services/binding_service.dart';
import 'package:grocery_nxt/Services/network_util.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils().getPrefs();
  NetworkUtil().listenForConnectionChanges();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,               // Only honored in Android M and above
    statusBarIconBrightness: Brightness.dark,   // Only honored in Android M and above
    statusBarBrightness: Brightness.light,      // Only honored in iOS
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context,w) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.native,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff23aa49)),
            fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
            applyElevationOverlayColor: false,
            useMaterial3: true,
          ),
          initialBinding: RootBinding(),
          home: SplashScreen(),
        );
      }
    );
  }
}


