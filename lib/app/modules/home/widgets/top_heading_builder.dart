import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/articles_detail_page.dart';
import 'package:getx_pattern/app/modules/search/model/articals_common_model.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:getx_pattern/app/modules/home/models/specific_news_model.dart'
    as aa;

class TopHeadingBuilder extends StatelessWidget {
  TopHeadingBuilder({
    Key? key,
    this.data,
  }) : super(key: key);

  Articles? data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        aa.Articles updatedData = aa.Articles(
            author: data!.author,
            publishedAt: data!.publishedAt,
            title: data!.title,
            description: data!.description,
            content: data!.content,
            url: data!.url,
            urlToImage: data!.urlToImage,
            source: aa.Source(
              name: data!.source!.name,
            ));
        Get.to(
          () => ArticleDetailPage(
            data: updatedData,
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
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: data!.urlToImage == null
                        ? Keys.NEWS_PLACEHOLDER
                        : GetUtils.isImage(data!.urlToImage!)
                            ? data!.urlToImage!
                            : Keys.NEWS_PLACEHOLDER,
                    fit: BoxFit.cover,
                    height: 220,
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
                   padding: EdgeInsets.all(4),
                    child: AppWidgets.buildText(
                      context: context,
                      text: timeUntil(DateTime.parse(data!.publishedAt!)),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'avenir_roman',
                      fontSize: 12,
                      color: Theme.of(context).textTheme.headline2!.color,
                    ),
                  ),
                ),
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
