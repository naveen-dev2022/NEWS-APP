import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/firebaseAuth.dart';
import 'package:sizer/sizer.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({Key? key}) : super(key: key);

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
 //  final _getStorage = GetStorage();

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
    /*  if (_getStorage.read(Keys.GET_TOKEN_KEY) == null) {
        Get.offAndToNamed(Routes.LOGIN);
      } else {
        Get.offAndToNamed(Routes.MAINSCREEN);
      }*/
      Get.offAll(()=>FirebaseAuthentication());
     // Get.to(()=>MainScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        color: Colors.black,
        child: Center(
          child: Image.asset(
            'assets/images/app_logo.jpg',
            height: 250,
            width: 250,
          ),
        ),
      ),
    );
  }

}
