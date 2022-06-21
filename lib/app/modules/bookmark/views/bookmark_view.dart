import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/app/modules/bookmark/widgets/bookmark_page.dart';
import 'package:getx_pattern/app/modules/login/controllers/login_controller.dart';
import 'package:getx_pattern/core/values/theme/themes_service.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class BookmarkView extends GetView<BookmarkController> {
  BookmarkView({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            children: [
              SizedBox(
                height: 8.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                      height: 15.h,
                      width: 30.w,
                    decoration: BoxDecoration(
                        borderRadius:  BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      borderRadius:BorderRadius.circular(8.0) ,
                      child: Get.find<LoginController>().isGuestMode.value?Image.asset('assets/images/profile_pic.png', fit: BoxFit.cover,):CachedNetworkImage(
                        imageUrl: user!.photoURL!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 100.w,
                child: AppWidgets.buildText(
                  context: context,
                    text: '${Get.find<LoginController>().isGuestMode.value?'Guest':user!.displayName ?? 'null'}',
                    fontSize: 25,
                    fontFamily: 'montserrat_bold'),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Get.find<LoginController>().isGuestMode.value?SizedBox():SizedBox(
                width: 100.w,
                child: AppWidgets.buildText(
                    context: context,
                    text: '${user!.email ?? 'null'}', fontSize: 13,fontFamily: 'montserrat_regular'),
              ),
              SizedBox(
                height: 5.h,
              ),
              ListTile(
                  leading: Icon(Icons.color_lens_outlined,size: 25,color: Theme.of(context).iconTheme.color,),
                  title: Row(
                    children: [
                      AppWidgets.buildText(
                          context: context,
                          text: 'Dark theme',fontSize: 15,fontFamily: 'montserrat_medium'),
                    Obx(()=>  Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: controller.appTheme.value,
                        onChanged: (value) {
                          ThemeService().changeThemeMode();
                        },
                        //  thumbColor: CupertinoColors.destructiveRed,
                        activeColor: CupertinoColors.activeBlue,
                      ),
                    ),)
                    ],
                  ),
                  onTap: () {
                    ThemeService().changeThemeMode();
                  }),
              Divider(),
              ListTile(
                  leading: Icon(Icons.favorite_border_outlined,size: 25,color: Theme.of(context).iconTheme.color,),
                  title:  AppWidgets.buildText(
                      context: context,
                      text: 'Favorite Articles', fontSize: 15,fontFamily: 'montserrat_medium'),
                  onTap: () {
                   Get.to(()=>BookmarkPage(controller: controller,),
                     transition: Transition.fadeIn,
                     duration: const Duration(milliseconds: 350),
                   );
                  }),
              Divider(),
              ListTile(
                  leading: Icon(Icons.share,size: 25,color: Theme.of(context).iconTheme.color,),
                  title:  AppWidgets.buildText(
                      context: context,
                      text: 'Share App', fontSize: 15,fontFamily: 'montserrat_medium'),
                  onTap: () {
                    // Home button action
                  }),
              Divider(),
              ListTile(
                  leading: Icon(Icons.settings,size: 25,color: Theme.of(context).iconTheme.color,),
                  title:  AppWidgets.buildText(
                      context: context,
                      text: 'App settings', fontSize: 15,fontFamily: 'montserrat_medium'),
                  onTap: () async{
                    await  openAppSettings();
                  }),
              Divider(),
              Get.find<LoginController>().isGuestMode.value?SizedBox():
              ListTile(
                  leading: Icon(Icons.power_settings_new_rounded,size: 25,color:Theme.of(context).iconTheme.color),
                  title: AppWidgets.buildText(
                      context: context,
                      text: 'Logout', fontSize: 15,fontFamily: 'montserrat_medium',color:  Colors.red.shade400),
                  onTap: () {
                    /*  getStorage.remove(Keys.GET_TOKEN_KEY);
                          Get.offAndToNamed(Routes.LOGIN);*/
                    Get.find<LoginController>().logout();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
