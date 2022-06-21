import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/modules/login/bindings/login_binding.dart';
import 'package:getx_pattern/app/modules/mainscreen.dart';
import 'package:getx_pattern/app/routes/app_pages.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:sizer/sizer.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {

  @override
  Widget build(BuildContext context) {
    void validate() {
      if (controller.emailController.value.text.isEmpty) {
        AppMethods.showSnackBar(
            context, 'Email is required', Colors.teal.shade200);
      } else if (!GetUtils.isEmail(controller.emailController.value.text)) {
        AppMethods.showSnackBar(
            context, 'Email is invalid', Colors.teal.shade200);
      } else if (controller.passwordController.value.text.isEmpty) {
        AppMethods.showSnackBar(
            context, 'Password is required', Colors.teal.shade200);
      } else if (!GetUtils.isLengthGreaterOrEqual(
          controller.passwordController.value.text, 6)) {
        AppMethods.showSnackBar(context, 'Password must be above 6 characters',
            Colors.teal.shade200);
      } else {
        controller
            .sendLoginData(controller.emailController.value.text,
                controller.passwordController.value.text)
            .then((value) => {
                  if (controller.loginModelData.value.data!.token != null)
                    {
                      controller.saveLoginToken(
                          controller.loginModelData.value.data!.token!),
                      Get.offAndToNamed(Routes.MAINSCREEN)
                    }
                });
      }
    }

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/login_image.jpg',
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 800),
                child: SizedBox(
                    width: 100.w,
                    child: AppWidgets.buildText(
                        text: 'Welcome back',
                        fontSize: 40,
                        color: Colors.white,
                      fontFamily: 'montserrat_bold'
                    )),
              ),
              SizedBox(
                height: 3.h,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1600),
                child: SizedBox(
                    width: 100.w,
                    child: AppWidgets.buildText(
                        text:
                        'Today or any day that phone may ring and bring good news.',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      fontFamily: 'montserrat_regular'
                    )),
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                DelayedDisplay(
                  delay: Duration(milliseconds: 0),
                  child: TextButton(
                    onPressed: () {
                      controller.googleLogin();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).iconTheme.color,
                          borderRadius: BorderRadius.circular(8.0)),
                      height: 50,
                      width: 40.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/google.png',height: 35,width: 35,),
                          SizedBox(width: 6,),
                          AppWidgets.buildText(
                              text: 'Login with\ngoogle',
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'montserrat_regular',
                            textAlign: TextAlign.start
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 0),
                  child: TextButton(
                    onPressed: () {
                      controller.isGuestMode.value=true;
                      Get.to(()=>MainScreen());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
                          border: Border.all(color:Theme.of(context).iconTheme.color!),
                          borderRadius: BorderRadius.circular(8.0)),
                      height: 50,
                      width: 35.w,
                      child:   Center(
                        child: AppWidgets.buildText(
                            text: 'Guest visit',
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'montserrat_regular'
                        ),
                      ),
                    ),
                  ),
                ),
              ],),

              /*  AppWidgets.buildText(text: 'LOGIN',fontSize: 22,color: Theme.of(context).iconTheme.color),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(hint:'Enter Email',textEditingController: controller.emailController.value,keyboardType: TextInputType.emailAddress,icon: Icons.email,issufixIcon: false,),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(hint:'Enter password',textEditingController: controller.passwordController.value,keyboardType: TextInputType.text,icon: Icons.security,obscureText: true,issufixIcon: false,),
                const SizedBox(
                  height: 5,
                ),

                Row(
                  mainAxisAlignment:  MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      controller.googleLogin();
                    }, child: const Text(
                        "Forget Password?"
                    ))
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),

                Button(child: AppWidgets.buildText(text: 'SIGN IN',fontSize: 18,color: Colors.white),colors: Colors.teal,onPressed: (){
                  validate();
                },),
                Obx(()=> controller.isLoading.value?CircularProgressIndicator():SizedBox()),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                      ),

                    ),
                    TextButton(onPressed: (){}, child: const Text(
                        "Register Account"
                    ))
                  ],
                ),*/
            ],
          ),
        ),
      ],
    ));
  }
}
