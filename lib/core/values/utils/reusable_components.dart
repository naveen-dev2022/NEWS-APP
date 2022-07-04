import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/modules/login/controllers/login_controller.dart';
import 'package:getx_pattern/app/modules/profile_screen.dart';
import 'package:getx_pattern/app/routes/app_pages.dart';
import 'package:getx_pattern/core/values/theme/themes_service.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class AppWidgets {
  static PreferredSizeWidget appbar(BuildContext context, {String? title}) {
    return AppBar(
      leading: IconButton(
        icon: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(50)),
            child: const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                Icons.arrow_back_ios,
                size: 15,
                color: Colors.black,
              ),
            )),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title ?? '',
        style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'montserrat_medium',
            fontWeight: FontWeight.w700),
      ),
    );
  }

  static Widget buildText(
      {required String? text,
        BuildContext? context,
      TextAlign? textAlign,
      double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily,
      int? maxline}) {
    return Text(
      text ?? '',
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxline ?? 20,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color ?? Theme.of(context!).textTheme.headline1!.color,
          fontSize: fontSize ?? 16,
          fontFamily: fontFamily ?? 'montserrat_medium',
          fontWeight: fontWeight ?? FontWeight.w700),
    );
  }

  static Widget myDrawer(GetStorage getStorage) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.live_tv),
                        title:  AppWidgets.buildText(text: 'Go live'),
                        onTap: () {
                          // Home button action
                        }),
                    ListTile(
                        leading: Icon(Icons.color_lens_outlined),
                        title: Row(
                          children: [
                            AppWidgets.buildText(text: 'Dark theme'),
                            SizedBox(width: 10,),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: GetStorage().read(Keys.THEME_STATUS_KEY),
                                onChanged: (value) {
                                  ThemeService().changeThemeMode();
                                },
                              //  thumbColor: CupertinoColors.destructiveRed,
                                activeColor: CupertinoColors.activeBlue,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          ThemeService().changeThemeMode();
                        }),
                    ListTile(
                        leading: Icon(Icons.logout),
                        title: AppWidgets.buildText(text: 'Logout'),
                        onTap: () {
                        /*  getStorage.remove(Keys.GET_TOKEN_KEY);
                          Get.offAndToNamed(Routes.LOGIN);*/
                          Get.find<LoginController>().logout();
                        })
                    //add more drawer menu here
                  ],
                ))),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Widget? child;
  final Function()? onPressed;
  final Color? colors;

  Button(
      {@required this.onPressed, @required this.child, @required this.colors});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
            constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: child),
      ),
      splashColor: Colors.black12,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}

class InternetConnectionError extends StatelessWidget {
  const InternetConnectionError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 3.h,
          ),
          CircleAvatar(
            radius: 120.0,
            backgroundImage: AssetImage(
              'assets/images/nointernet.gif',
            ),
          ),
          SizedBox(height: 2.h,),
          SizedBox(
            width: 100.w,
            child: AppWidgets.buildText(
              context: context,
              text:
              "Oops!",
              fontSize: 14,
              textAlign: TextAlign.center,
              fontFamily: 'gotham_medium',
            ),
          ),
          SizedBox(
            width: 100.w,
            child: AppWidgets.buildText(
              context: context,
              text:
                  "Slow or no internet connection. Please check your internet connection.",
              fontSize: 14,
              textAlign: TextAlign.center,
              fontFamily: 'gotham_medium',
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class NoBookmarkFound extends StatelessWidget {
  NoBookmarkFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 120.0,
            backgroundImage: AssetImage(
              'assets/images/no_bookmark.jpeg',
            ),
          ),
          SizedBox(height: 3.h,),
          SizedBox(
            width: 100.w,
            child: AppWidgets.buildText(
              context: context,
              text:
              "Looks like no bookmark added here.",
              fontSize: 14,
              textAlign: TextAlign.center,
              fontFamily: 'gotham_medium',
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  ErrorMessage({Key? key, this.errorMessage, this.onPressed}) : super(key: key);

  String? errorMessage;
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.asset(
                'assets/images/error_img.png.webp',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xff2c0453),
                border: Border.all(color: Color(0xff2c0453)),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0))),
          )
        ],
      ),
      Positioned(
        bottom: 20,
        child: SizedBox(
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppWidgets.buildText(
                  context: context,
                  text: '${errorMessage} !!', color: Colors.white,fontFamily: 'gotham_medium'),
              SizedBox(
                height: 5,
              ),
              TextButton(
                  onPressed: onPressed,
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Center(
                      child: AppWidgets.buildText(
                          context: context,
                          text: 'Retry'),
                    ),
                  ))
            ],
          ),
        ),
      )
    ]);
  }
}

class ListViewSkeletonLoader extends StatelessWidget {
  ListViewSkeletonLoader({Key? key, this.itemCount}) : super(key: key);

  int? itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      items: itemCount ?? 6,
      period: Duration(seconds: 2),
      highlightColor: Theme.of(context).iconTheme.color!,
      direction: SkeletonDirection.ltr,
    );
  }
}

class GridViewSkeletonLoader extends StatelessWidget {
  GridViewSkeletonLoader(
      {Key? key, this.itemCount, this.itemsPerRow, this.childAspectRatio})
      : super(key: key);

  int? itemCount;
  int? itemsPerRow;
  double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return SkeletonGridLoader(
      builder: Card(
        color: Colors.transparent,
        child: GridTile(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 10,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Container(
                width: 70,
                height: 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      items: itemCount ?? 12,
      itemsPerRow: itemsPerRow ?? 2,
      period: Duration(seconds: 2),
      highlightColor: Theme.of(context).iconTheme.color!,
      direction: SkeletonDirection.ltr,
      childAspectRatio: childAspectRatio ?? 1.0,
    );
  }
}

class TopChannelSkeletonLoader extends StatelessWidget {
  TopChannelSkeletonLoader({Key? key, this.itemCount}) : super(key: key);

  int? itemCount;

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                SizedBox(height: 10),
                Container(
                  width: 100,
                  height: 10,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Container(
                  width: 70,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                SizedBox(height: 10),
                Container(
                  width: 100,
                  height: 10,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Container(
                  width: 70,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                SizedBox(height: 10),
                Container(
                  width: 100,
                  height: 10,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Container(
                  width: 70,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
      items: itemCount ?? 6,
      period: Duration(seconds: 2),
      highlightColor: Colors.lightBlue[300]!,
      direction: SkeletonDirection.ltr,
    );
  }
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}
