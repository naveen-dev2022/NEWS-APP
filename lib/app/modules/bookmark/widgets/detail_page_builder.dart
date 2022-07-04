import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/app/modules/bookmark/model/articals_common_model.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class SavedArticleDetailBuilder extends StatelessWidget {
  SavedArticleDetailBuilder({Key? key, this.data}) : super(key: key);

  Favorite? data;

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        child: ListView(
          children: [
            Container(
              height: 55.h,
              width: 100.w,
              color: Colors.grey.shade100,
              child: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: CachedNetworkImage(
                      imageUrl: data!.urlToImage == null
                          ? Keys.NEWS_PLACEHOLDER
                          : data!.urlToImage!,
                      height: 40.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String url) => Center(
                        child: SpinKitRipple(
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        height: 22.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Card(
                          elevation: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppWidgets.buildText(
                                context: context,
                                text: data!.name == '' ? '' : data!.name,
                                fontFamily: 'montserrat_bold',
                                fontSize: 18,
                              ),
                              AppWidgets.buildText(
                                context: context,
                                text: data!.author == '' ? '' : data!.author,
                                fontSize: 12,
                                fontFamily: 'gotham_light',
                                color: Colors.grey.shade500,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, right: 18),
                                child: Divider(
                                  thickness: 0.6,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: AppWidgets.buildText(
                                  context: context,
                                  text: data!.title == '' ? '' : data!.title,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'poppins_regular',
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppWidgets.buildText(
                                    context: context,
                                    text: timeUntil(
                                        DateTime.parse(data!.publishedAt!)),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'avenir_roman',
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    child: IconButton(
                      icon: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
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
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AppWidgets.buildText(
                      context: context,
                      text: 'Description',
                      fontWeight: FontWeight.w500,
                      fontFamily: 'montserrat_bold',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AppWidgets.buildText(
                      context: context,
                      text: data!.description == '' ? '' : data!.description,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'poppins_regular',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AppWidgets.buildText(
                      context: context,
                      text: 'Content',
                      fontWeight: FontWeight.w500,
                      fontFamily: 'montserrat_bold',
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AppWidgets.buildText(
                      context: context,
                      text: data!.content == ''
                          ? ''
                          : data!.content!.contains('[')
                              ? data!.content!
                                  .substring(0, data!.content!.indexOf('['))
                              : data!.content!,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'poppins_regular',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    child: Divider(
                      thickness: 0.6,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: AppWidgets.buildText(
                      context: context,
                      text: 'Read More',
                      fontWeight: FontWeight.w500,
                      fontFamily: 'gotham_bold',
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
