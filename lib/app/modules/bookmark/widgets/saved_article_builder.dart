





import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/app/modules/bookmark/model/articals_common_model.dart';
import 'package:getx_pattern/app/modules/bookmark/widgets/detail_page_builder.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:getx_pattern/core/values/utils/reusable_components.dart';


class SavedArticleBuilder extends StatelessWidget {
  SavedArticleBuilder({
    Key? key,
    this.data,
  }) : super(key: key);

  Favorite? data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
              () => SavedArticleDetailBuilder(
            data: data!,
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 350),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Card(
          elevation: 0,
          child: Container(
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: CachedNetworkImage(
                    imageUrl: data!.urlToImage == null
                        ? Keys.NEWS_PLACEHOLDER
                        : GetUtils.isImage(data!.urlToImage!)
                        ? data!.urlToImage!
                        : Keys.NEWS_PLACEHOLDER,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    color: Color(0xff121212).withOpacity(0.4),
                    colorBlendMode: BlendMode.softLight,
                    placeholder: (BuildContext context, String url) => Center(
                      child: SpinKitRipple(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    errorWidget:
                        (BuildContext context, String url, dynamic error) =>
                    const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    height: 40,
                    width: 90.w,
                    padding: EdgeInsets.only(left: 5),
                    color: Colors.black54,
                    child: Center(
                      child: AppWidgets.buildText(
                        context: context,
                          maxline: 2,
                          text: data!.title,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'avenir_roman',
                          fontSize: 13,
                          color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppWidgets.buildText(
                        context: context,
                        text: timeUntil(DateTime.parse(data!.publishedAt!)),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'avenir_roman',
                        fontSize: 13,
                        color: Theme.of(context).textTheme.headline3!.color,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: (){
                        for (int i = 0;
                        i <
                            Get.find<BookmarkController>()
                                .SavedArticle
                                .length;
                        i++) {
                          if (Get.find<BookmarkController>()
                              .SavedArticle[i]
                              .title ==
                              data!.title) {
                            AppMethods.showSnackBar(
                                context,
                                'Article removed successfully',
                                Theme.of(context).iconTheme.color);
                            Get.find<BookmarkController>()
                                .SavedArticle
                                .removeAt(i);
                            break;
                          }
                        }

                        final json = jsonEncode(
                            Get.find<BookmarkController>()
                                .SavedArticle);

                        Get.find<BookmarkController>()
                            .getStorage
                            .write(Keys.BOOKMARK_ARTICLES, json);
                      },
                      child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              size: 22,
                            ),
                          ),),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String timeUntil(DateTime date) {
  return timeago.format(date, allowFromNow: true);
}
