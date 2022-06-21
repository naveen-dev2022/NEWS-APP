import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/data/providers/dio_connectivity_request_retrier.dart';
import 'package:getx_pattern/app/data/providers/interceptors.dart';
import 'package:getx_pattern/app/modules/home/models/specific_news_model.dart';
import 'package:getx_pattern/app/modules/home/models/top_channel_model.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';


class TopChannelController extends GetxController {
  //TODO: Implement HomeController

  RxList<Sources> topNewsChannelData = <Sources>[].obs;
  Iterable<List<Sources>> split = [];
  ScrollController scrollController = ScrollController();
  var isLoadingTopChannel = false.obs;
  var isPaginationLoading = false.obs;
  var topChannelModelData = NewsTopChannelsModel().obs;
  double? _scrollThreshold = 170.0;
  var isLoadingNewsSpecificSource = false.obs;
  var specificSourceData=SpecificNewsModel().obs;
  int? fullPageCount;
  int position = 0;
  RxBool isInternetAvailable = true.obs;
  RxBool isSourceInternetAvailable = true.obs;

  @override
  void onInit() {
    fetchTopNewsChannelData();
    super.onInit();
  }

  @override
  void onReady() {
    addItems();
    super.onReady();
  }

  @override
  void onClose() {}

  addItems() async {
    scrollController.addListener(() {
      if ((scrollController.position.maxScrollExtent -
              scrollController.position.pixels) <=
          _scrollThreshold!) {
        if ((scrollController.position.maxScrollExtent - scrollController.position.pixels) <=_scrollThreshold!  && !isPaginationLoading.value) {
          if(position < fullPageCount!){
            isPaginationLoading(true);
            Future.delayed(Duration(milliseconds: 1000), (){
              print('Future.delayed-----');
            }).then((value){
              topNewsChannelData.addAll(split.elementAt(position));
              position=position+1;
              isPaginationLoading(false);
            });
          }
        }
      }
    });
  }

  Future<void> fetchTopNewsChannelData() async {
    Dio? dio = Dio();

    dio.interceptors.add(
      TopNewsChannelInterceptor1(
        requestRetry: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    isLoadingTopChannel(true);

    await dio.get('${Keys.GET_NEWS_BASEURL_KEY}/sources');
  }

  Future<void> fetchTopNewsSpecificSourceData(String? source) async {
    Dio? dio = Dio();

    dio.interceptors.add(
      TopNewsSpecificChannelInterceptor1(
        source: source,
        requestRetry: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    isLoadingNewsSpecificSource(true);

    await dio.get<Map<String, dynamic>>(
      '${Keys.GET_NEWS_BASEURL_KEY}/top-headlines',
    );
  }


}
