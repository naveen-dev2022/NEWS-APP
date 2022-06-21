import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/articles_detail_page.dart';
import 'package:getx_pattern/app/modules/home/models/specific_news_model.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class SpecificSourceBuilder extends StatelessWidget {
  SpecificSourceBuilder({Key? key, this.data}) : super(key: key);

  Articles? data;

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ArticleDetailPage(
            data: data,
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 350),
        );
      },
      child: Container(
          height: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: data!.urlToImage == null
                      ? Keys.NEWS_PLACEHOLDER
                      : GetUtils.isImage(data!.urlToImage!)
                      ? data!.urlToImage!
                      : Keys.NEWS_PLACEHOLDER,
                  height: 100,
                  width: 120,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) => Center(
                    child: SpinKitRipple(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 60.w,
                    child: AppWidgets.buildText(
                      context: context,
                      text: data!.title!,
                      fontSize: 12,
                      fontFamily: 'montserrat_medium',
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    width: 60.w,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: AppWidgets.buildText(
                        context: context,
                        text: timeUntil(DateTime.parse(data!.publishedAt!)),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'avenir_roman',
                        fontSize: 11,
                        color: Theme.of(context).textTheme.headline2!.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
