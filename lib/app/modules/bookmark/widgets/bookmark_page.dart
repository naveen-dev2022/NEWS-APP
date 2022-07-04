import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/app/modules/bookmark/widgets/saved_article_builder.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/values/utils/reusable_components.dart';

class BookmarkPage extends StatelessWidget {
  BookmarkPage({Key? key, this.controller}) : super(key: key);

  BookmarkController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:AppWidgets.buildText(
        context: context,
          text: 'Bookmarked Articles',
          fontSize: 22,
          fontFamily: 'montserrat_bold',
          ) ,
      elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 22,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Obx(
              () => controller!.SavedArticle.isEmpty
                  ? NoBookmarkFound()
                  : ListView.builder(
                      itemCount: controller!.SavedArticle.length,
                      addAutomaticKeepAlives: true,
                      shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SavedArticleBuilder(
                          data: controller!.SavedArticle[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
