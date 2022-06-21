import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/channels/controllers/top_channel_controller.dart';
import 'package:getx_pattern/app/modules/channels/widgets/channel_source_builder.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:sizer/sizer.dart';

class TopNewsChannel extends GetView<TopChannelController> {
  const TopNewsChannel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => controller.isInternetAvailable.value
            ? Container(
                height: 100.h,
                width: double.infinity,
                padding: EdgeInsets.only(left: 8, right: 8),
                child: CustomScrollView(
                  controller: controller.scrollController,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 6.h,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: 100.w,
                        child: AppWidgets.buildText(
                          context: context,
                            text: 'Top channels',
                            fontSize: 22,
                            fontFamily: 'montserrat_bold',
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 2.h,
                      ),
                    ),
                    controller.isLoadingTopChannel.value
                        ? SliverToBoxAdapter(child: GridViewSkeletonLoader())
                        : controller.topChannelModelData.value.error == null
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.2,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext c, int i) {
                                  return i >=
                                          controller.topNewsChannelData.length
                                      ? const Text('No data found')
                                      : TopChannelSourceBuilder(
                                          data:
                                              controller.topNewsChannelData[i],
                                          controller: controller,
                                        );
                                },
                                    childCount:
                                        controller.topNewsChannelData.length),
                              )
                            : SliverToBoxAdapter(
                                child: ErrorMessage(
                                  errorMessage: controller
                                      .topChannelModelData.value.error,
                                  onPressed: () {
                                    controller.fetchTopNewsChannelData();
                                  },
                                ),
                              ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 1.h,
                      ),
                    ),
                    controller.isPaginationLoading.value
                        ? SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()))
                        : SliverToBoxAdapter(child: SizedBox())
                  ],
                ),
              )
            : InternetConnectionError()));
  }
}
