import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_nxt/Pages/SplashScreen/splash_screen.dart';
import 'package:grocery_nxt/Utils/shared_pref_utils.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils().getPrefs();
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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff23aa49)),
            fontFamily: GoogleFonts.exo().fontFamily,
            useMaterial3: true,
          ),
          home: SplashScreen(),
        );
      }
    );
  }
}


