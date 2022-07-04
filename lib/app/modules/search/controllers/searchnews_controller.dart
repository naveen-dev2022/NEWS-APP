import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/data/providers/dio_connectivity_request_retrier.dart';
import 'package:getx_pattern/app/data/providers/interceptors.dart';
import 'package:getx_pattern/app/modules/search/model/articals_common_model.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';

class SearchNewsController extends GetxController {
  //TODO: Implement HomeController

  var isLoadingSearchNews = false.obs;
  var searchNewsData = ArticlesCommonModel().obs;
  Rx<TextEditingController> searchNewsController = TextEditingController(text: 'apple').obs;
  RxBool isInternetAvailable = true.obs;
  RxList<bool> languageBGColorList = <bool>[].obs;
  RxList<bool> sortByBGColorList = <bool>[].obs;
  RxString fromDateValue = ''.obs;
  RxString toDateValue = ''.obs;
  RxString languageValue = ''.obs;
  RxString sortByValue = ''.obs;
  DateTime now=DateTime.now();

  var countryCode = [
    {"language": "Arabic", "code": "ar"},
    {"language": "German", "code": "de"},
    {"language": "English", "code": "en"},
    {"language": "Spanish", "code": "es"},
    {"language": "French", "code": "fr"},
    {"language": "Hebrew", "code": "he"},
    {"language": "Italian", "code": "it"},
    {"language": "Dutch", "code": "nl"},
    {"language": "Norwegian", "code": "no"},
    {"language": "Portuguese", "code": "pt"},
    {"language": "Russian", "code": "ru"},
    {"language": "Swedish", "code": "sv"},
    {"language": "Chinese", "code": "zh"},
  ];

  var sortBy = [
    {"key": "relevancy", 'disc': 'Articles more closely related '},
    {
      "key": "popularity",
      'disc': 'Articles from popular sources and publishers come first'
    },
    {"key": "publishedAt", 'disc': 'Newest articles come first'},
  ];

   initialaizeSearchFilters(){
     fromDateValue.value='${now.year}-${now.month}-${now.day-1}';
     toDateValue.value='${now.year}-${now.month}-${now.day}';
     languageValue.value='en';
     sortByValue.value='relevancy';
   }

  @override
  void onInit() {
    initialaizeSearchFilters();
    languageBGColorList =
        RxList.filled(countryCode.length, false, growable: false);
    sortByBGColorList = RxList.filled(sortBy.length, false, growable: false);
    fetchSearchNewsData(searchNewsController.value.text,fromDateValue.value,toDateValue.value,languageValue.value,sortByValue.value);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> fetchSearchNewsData(String? search, String? fromDate,
      String? toDate, String? language, String? sortBy) async {
    Dio? dio = Dio();

    dio.interceptors.add(
      SearchNewsInterceptor(
        search: search,
        fromDate: fromDate,
        toDate: toDate,
        sortBy: sortBy,
        language: language,
        requestRetry: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    isLoadingSearchNews(true);

    await dio.get(
      '${Keys.GET_NEWS_BASEURL_KEY}/everything',
    );
  }

}
