import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/app/modules/home/models/specific_news_model.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import 'bookmark/model/articals_common_model.dart' as common;

class ArticleDetailPage extends StatefulWidget {
  ArticleDetailPage({Key? key, this.data}) : super(key: key);

  Articles? data;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }

  final _getStorage = GetStorage();
  common.Favorite? storeData;
  RxBool isSaved = false.obs;
  final bookmarkedController = Get.find<BookmarkController>();

  @override
  void initState() {
    print('content#########---->>>${widget.data!.content}');

    storeData = common.Favorite(
        id: widget.data!.source!.id,
        name: widget.data!.source!.name,
        author: widget.data!.author,
        publishedAt: widget.data!.publishedAt,
        title: widget.data!.title,
        description: widget.data!.description,
        content: widget.data!.content,
        url: widget.data!.url,
        urlToImage: widget.data!.urlToImage);

    for (int i = 0; i < bookmarkedController.SavedArticle.length; i++) {
      if (bookmarkedController.SavedArticle[i].title == storeData!.title) {
        isSaved.value = true;
        break;
      }
    }

    super.initState();
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
                        colors: [Colors.black,Colors.black87,Colors.transparent],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: CachedNetworkImage(
                      imageUrl: widget.data!.urlToImage == null
                          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                          : widget.data!.urlToImage!,
                      height: 40.h,
                      width: 100.w,
                      fit: BoxFit.fill,
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
                                text: widget.data!.source!.name,
                                fontFamily: 'montserrat_bold',
                                fontSize: 16,
                              ),
                              AppWidgets.buildText(
                                text: widget.data!.author,
                                fontSize: 12,
                                fontFamily: 'gotham_light',
                                color: Theme.of(context).textTheme.headline3!.color,
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
                                  text: widget.data!.title,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'poppins_regular',
                                  fontSize: 13,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppWidgets.buildText(
                                    context: context,
                                    text: timeUntil(DateTime.parse(
                                        widget.data!.publishedAt!)),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'avenir_roman',
                                    fontSize: 12,
                                    color: Theme.of(context).textTheme.headline3!.color,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                            ),
                          )),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  Positioned(
                      right: 35,
                      bottom: 22.h,
                      child: Obx(
                        () => Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                              icon: Icon(
                                isSaved.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 25,
                              ),
                              onPressed: () {
                                if (bookmarkedController.SavedArticle.isEmpty) {
                                  AppMethods.showSnackBar(context,
                                      'Article saved successfully', Theme.of(context).iconTheme.color);
                                  bookmarkedController.SavedArticle.add(
                                      storeData!);
                                  isSaved.value = !isSaved.value;
                                } else {
                                  for (int i = 0;
                                      i <
                                          bookmarkedController
                                              .SavedArticle.length;
                                      i++) {
                                    if (bookmarkedController
                                            .SavedArticle[i].title ==
                                        storeData!.title) {
                                      AppMethods.showSnackBar(
                                          context,
                                          'Article removed successfully',
                                          Theme.of(context).iconTheme.color);
                                      isSaved.value = !isSaved.value;
                                      bookmarkedController.SavedArticle
                                          .removeAt(i);
                                      break;
                                    } else if (i ==
                                        bookmarkedController
                                                .SavedArticle.length -
                                            1) {
                                      AppMethods.showSnackBar(
                                          context,
                                          'Article saved successfully',
                                          Theme.of(context).iconTheme.color);
                                      bookmarkedController.SavedArticle.add(
                                          storeData!);
                                      isSaved.value = !isSaved.value;
                                      break;
                                    }
                                  }
                                }

                                final json = jsonEncode(
                                    bookmarkedController.SavedArticle);

                                _getStorage.write(Keys.BOOKMARK_ARTICLES, json);
                              },
                            )),
                      )),
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
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AppWidgets.buildText(
                      context: context,
                      text: widget.data!.description,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'poppins_regular',
                      fontSize: 13,
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
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AppWidgets.buildText(
                      context: context,
                      text: widget.data!.content == null
                          ? ''
                          : widget.data!.content!.contains('[')
                              ? widget.data!.content!.substring(
                                  0, widget.data!.content!.indexOf('['))
                              : widget.data!.content!,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'poppins_regular',
                      fontSize: 13,
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
                    onPressed: () async{
                      final Uri _url = Uri.parse(widget.data!.url!);
                      if (!await launchUrl(_url)) throw Fluttertoast.showToast(msg: 'Could not launch url');
                    },
                    child: AppWidgets.buildText(
                      context: context,
                      text: 'Read More',
                      fontWeight: FontWeight.w500,
                      fontFamily: 'gotham_bold',
                      fontSize: 16,
                      color: Theme.of(context).iconTheme.color
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
