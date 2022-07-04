import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/data/providers/dio_connectivity_request_retrier.dart';
import 'package:getx_pattern/app/data/providers/exceptions.dart';
import 'package:getx_pattern/app/modules/channels/controllers/top_channel_controller.dart';
import 'package:getx_pattern/app/modules/home/controllers/home_controller.dart';
import 'package:getx_pattern/app/modules/home/models/specific_news_model.dart';
import 'package:getx_pattern/app/modules/home/models/top_channel_model.dart';
import 'package:getx_pattern/app/modules/home/models/weather_model.dart';
import 'package:getx_pattern/app/modules/search/controllers/searchnews_controller.dart';
import 'package:getx_pattern/app/modules/search/model/articals_common_model.dart'
    as common;
import 'package:getx_pattern/app/modules/search/model/articals_common_model.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:quiver/iterables.dart';

///Interceptor block requests ,response,error
///@@@@@Retry On Connection Change

class weatherInterceptor extends Interceptor {
  weatherInterceptor({@required this.requestRetry, this.place});

  DioConnectivityRequestRetry? requestRetry;
  String? place;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('requesting#####');

    options.queryParameters = {
      "q": place,
      "units": "metric",
      "APPID": Keys.GET_WEATHER_API_KEY
    };

    return super.onRequest(options, handler); //add this  //add this line
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    print(response.statusCode);
    print('error######${response.data}');

    try {
      if (response.statusCode == 200) {
        print('responseData######${response.data}');
        final Map<String, dynamic> map =
        Map<String, dynamic>.from(response.data!);
        Get.find<HomeController>().weatherModelData.value =
            WeatherModel.fromJson(map);
        Get.find<HomeController>().isLoading(false);
      }

      ///no content available
      else if (response.statusCode == 204) {
        Get.find<HomeController>().isLoading(false);
      }

    } catch (error) {
      if (error is! Exception) {
        if (error.toString().contains("is not a subtype of")) {
          Get.find<HomeController>().weatherModelData.value.error =
          'Type Error';
          Get.find<HomeController>().isLoading(false);
        }
      }
    }

    // do something before response
    return super.onResponse(response, handler); //add this line//add this line
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      if (err.type == DioErrorType.other &&
          err.error != null &&
          err.error is SocketException) {
        Get.find<HomeController>().isInternetAvailable(false);
        requestRetry!.scheduleRequestRetry(err.requestOptions).then((value) {
          print('!!!ConnectivityResult##########');
          Get.find<HomeController>().isInternetAvailable(true);
        });
      } else {
        String errorMessage = Exceptions.DioExceptions(err);
        if(errorMessage.contains('Page not found')){
          Get.find<HomeController>().isLoading(false);
          Get.find<HomeController>().isInternetAvailable(true);
          AppMethods.GetxSnackBar('City not found');
        }else{
          Get.find<HomeController>().weatherModelData.value.error = errorMessage;
          Get.find<HomeController>().isLoading(false);
          Get.find<HomeController>().isInternetAvailable(true);
          AppMethods.GetxSnackBar(errorMessage);
        }
      }
    } on FormatException catch (e) {
      Get.find<HomeController>().weatherModelData.value.error =
          'Format exception';
      Get.find<HomeController>().isLoading(false);
      Get.find<HomeController>().isInternetAvailable(true);
    }

    return super.onError(err, handler);
  }
}

///Top news
class TopNewsChannelInterceptor extends Interceptor {
  TopNewsChannelInterceptor({@required this.requestRetry});

  final DioConnectivityRequestRetry? requestRetry;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    options.queryParameters = {
      "apiKey": Keys.GET_NEWS_API_KEY,
      "language": "en",
      "country": "us"
    };

    ///   options.headers['token'] = 'bearer 465456845345345';

    return super.onRequest(options, handler); //add this line
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    try {
      if (response.statusCode == 200) {
        print('responseData######${response.data}');
        final Map<String, dynamic> map =
            Map<String, dynamic>.from(response.data!);
        Get.find<HomeController>().topNewChannelModelData.value =
            NewsTopChannelsModel.fromJson(map);
        Get.find<HomeController>().isLoadingTopChannel(false);
      }

      ///no content available
      else if (response.statusCode == 204) {
        Get.find<HomeController>().topNewChannelModelData.value.sources = [];
        Get.find<HomeController>().isLoadingTopChannel(false);
      }
    } catch (error) {
      if (error is! Exception) {
        if (error.toString().contains("is not a subtype of")) {
          Get.find<HomeController>().topNewChannelModelData.value.error =
              'Type Error';
          Get.find<HomeController>().isLoadingTopChannel(false);
        }
      }
    }

    // do something before response
    return super.onResponse(response, handler); //add this line
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      if (err.type == DioErrorType.other &&
          err.error != null &&
          err.error is SocketException) {
        Get.find<HomeController>().isInternetAvailable(false);
        requestRetry!.scheduleRequestRetry(err.requestOptions).then((value) {
          print('!!!ConnectivityResult##########');
          Get.find<HomeController>().isInternetAvailable(true);
        });
      } else {
        String errorMessage = Exceptions.DioExceptions(err);
        Get.find<HomeController>().topNewChannelModelData.value.error =
            errorMessage;
        Get.find<HomeController>().isLoadingTopChannel(false);
        Get.find<HomeController>().isInternetAvailable(true);
      }
    } on FormatException catch (e) {
      Get.find<HomeController>().topNewChannelModelData.value.error =
          'Format exception';
      Get.find<HomeController>().isLoadingTopChannel(false);
      Get.find<HomeController>().isInternetAvailable(true);
    }

    return super.onError(err, handler);
  }
}

///Top news specific
class TopNewsSpecificChannelInterceptor extends Interceptor {
  final DioConnectivityRequestRetry? requestRetry;

  TopNewsSpecificChannelInterceptor({@required this.requestRetry,this.source});
  String? source;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('requesting#####');
    options.queryParameters={"apiKey": Keys.GET_NEWS_API_KEY, "sources": source};
    return super.onRequest(options, handler); //add this  //add this line
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {

    try {
      if (response.statusCode == 200) {
        print('responseData######${response.data}');
        final Map<String, dynamic> map =
        Map<String, dynamic>.from(response.data!);
        Get.find<HomeController>().specificSourceData.value =
            SpecificNewsModel.fromJson(map);
        Get.find<HomeController>().isLoadingNewsSpecificSource(false);
      }

      ///no content available
      else if (response.statusCode == 204) {
        Get.find<HomeController>().specificSourceData.value.articles = [];
        Get.find<HomeController>().isLoadingNewsSpecificSource(false);
      }
    } catch (error) {
      if (error is! Exception) {
        if (error.toString().contains("is not a subtype of")) {
          Get.find<HomeController>().specificSourceData.value.error =
          'Type Error';
          Get.find<HomeController>().isLoadingNewsSpecificSource(false);
        }
      }
    }
    return super.onResponse(response, handler); //add this line
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {

    try {
      if (err.type == DioErrorType.other &&
          err.error != null &&
          err.error is SocketException) {
        Get.find<HomeController>().isSourceInternetAvailable(false);
        requestRetry!.scheduleRequestRetry(err.requestOptions).then((value) {
          print('!!!ConnectivityResult##########');
          Get.find<HomeController>().isSourceInternetAvailable(true);
        });
      } else {
        String errorMessage = Exceptions.DioExceptions(err);
        Get.find<HomeController>().specificSourceData.value.error =
            errorMessage;
        Get.find<HomeController>().isLoadingNewsSpecificSource(false);
        Get.find<HomeController>().isSourceInternetAvailable(true);
      }
    } on FormatException catch (e) {
      Get.find<HomeController>().topNewChannelModelData.value.error =
      'Format exception';
      Get.find<HomeController>().isLoadingNewsSpecificSource(false);
      Get.find<HomeController>().isSourceInternetAvailable(true);
    }

    return super.onError(err, handler);
  }

}

/// Weather

///Top heading
class TopHeadingInterceptor extends Interceptor {

  final DioConnectivityRequestRetry? requestRetry;
  String? country;

  TopHeadingInterceptor({@required this.requestRetry,this.country});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('requesting#####');
    options.queryParameters={"apiKey": Keys.GET_NEWS_API_KEY, "country": country};
   return super.onRequest(options, handler); //add this line
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    print(response.statusCode);

    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(response.data!);
        Get.find<HomeController>().topHeadingModelData.value =
            common.ArticlesCommonModel.fromJson(map);
        Get.find<HomeController>().split = partition<common.Articles>(
            Get.find<HomeController>().topHeadingModelData.value.articles!, 10);
        Get.find<HomeController>().fullPageCount =
            Get.find<HomeController>().split.length;
        Get.find<HomeController>().articles.value = Get.find<HomeController>()
            .split
            .elementAt(Get.find<HomeController>().position);
        Get.find<HomeController>().position =
            Get.find<HomeController>().position + 1;
        print('responseData######${response.data}');
        Get.find<HomeController>().isLoadingTopHeading(false);
      }

      ///no content available
      else if (response.statusCode == 204) {
        Get.find<HomeController>().topHeadingModelData.value.articles = [];
        Get.find<HomeController>().isLoadingTopHeading(false);
      }
    } catch (error) {
      if (error is! Exception) {
        if (error.toString().contains("is not a subtype of")) {
          Get.find<HomeController>().topHeadingModelData.value.error =
          'Type Error';
          Get.find<HomeController>().isLoadingTopHeading(false);
        }
      }
    }
    // do something before response
   return super.onResponse(response, handler); //add this line
  }


  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {

    try {
      if (err.type == DioErrorType.other &&
          err.error != null &&
          err.error is SocketException) {
        Get.find<HomeController>().isInternetAvailable(false);
        requestRetry!.scheduleRequestRetry(err.requestOptions).then((value) {
          print('!!!ConnectivityResult##########');
          Get.find<HomeController>().isInternetAvailable(true);
        });
      } else {
        String errorMessage = Exceptions.DioExceptions(err);
        Get.find<HomeController>().topHeadingModelData.value.error =
            errorMessage;
        Get.find<HomeController>().isLoadingTopHeading(false);
        Get.find<HomeController>().isInternetAvailable(true);
      }
    } on FormatException catch (e) {
      Get.find<HomeController>().topHeadingModelData.value.error =
      'Format exception';
      Get.find<HomeController>().isLoadingTopHeading(false);
      Get.find<HomeController>().isInternetAvailable(true);
    }

   return super.onError(err, handler);
  }


}

///Search news
class SearchNewsInterceptor extends Interceptor {

  final DioConnectivityRequestRetry? requestRetry;
  String? search;
  String? fromDate;
  String? sortBy;
  String? language;
  String? toDate;

  SearchNewsInterceptor({@required this.requestRetry,this.search,this.fromDate,this.toDate,this.sortBy,this.language});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('requesting#####');
    options.queryParameters={"apiKey": Keys.GET_NEWS_API_KEY, "q": search??'apple','from':fromDate??'2022-30-04','to':toDate??'2022-30-05','sortBy':sortBy??'popularity','language':language??'en'};
    return super.onRequest(options, handler); //add this line
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {

    try {
      if (response.statusCode == 200) {
        print('responseData######search${response.data}');
        final Map<String, dynamic> map =
        Map<String, dynamic>.from(response.data!);
        Get.find<SearchNewsController>().searchNewsData.value =
            ArticlesCommonModel.fromJson(map);
        if(Get.find<SearchNewsController>().searchNewsData.value.articles!.isEmpty){
          AppMethods.GetxSnackBar('Article not found');
        }
        Get.find<SearchNewsController>().isLoadingSearchNews(false);
      }

      ///no content available
      else if (response.statusCode == 204) {

        Get.find<SearchNewsController>().searchNewsData.value.articles=[];
        Get.find<SearchNewsController>().isLoadingSearchNews(false);
      }

    } catch (error) {
      if (error is! Exception) {
        if (error.toString().contains("is not a subtype of")) {
          Get.find<SearchNewsController>().searchNewsData.value.error =
          'Type Error';
          Get.find<SearchNewsController>().isLoadingSearchNews(false);
        }
      }
    }

    // do something before response
    return super.onResponse(response, handler); //add this line
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {

    try {
      if (err.type == DioErrorType.other &&
          err.error != null &&
          err.error is SocketException) {
        Get.find<SearchNewsController>().isInternetAvailable(false);
        requestRetry!.scheduleRequestRetry(err.requestOptions).then((value) {
          print('!!!ConnectivityResult##########');
          Get.find<SearchNewsController>().isInternetAvailable(true);
        });
      } else {
        String errorMessage = Exceptions.DioExceptions(err);
        Get.find<SearchNewsController>().searchNewsData.value.error =
            errorMessage;
        Get.find<SearchNewsController>().isLoadingSearchNews(false);
        Get.find<SearchNewsController>().isInternetAvailable(true);
      }
    } on FormatException catch (e) {
      Get.find<HomeController>().topHeadingModelData.value.error =
      'Format exception';
      Get.find<SearchNewsController>().isLoadingSearchNews(false);
      Get.find<SearchNewsController>().isInternetAvailable(true);
    }

    return super.onError(err, handler);
  }


}


///Top news2
class TopNewsChannelInterceptor1 extends Interceptor {
  TopNewsChannelInterceptor1({@required this.requestRetry});

  final DioConnectivityRequestRetry? requestRetry;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    options.queryParameters = {
      "apiKey": Keys.GET_NEWS_API_KEY,
      "language": "en",
      "country": "us"
    };

    ///   options.headers['token'] = 'bearer 465456845345345';

    return super.onRequest(options, handler); //add this line
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {

    try {
      if (response.statusCode == 200) {
        print('responseData######${response.data}');
        final Map<String, dynamic> map = Map<String, dynamic>.from(response.data!);
        Get.find<TopChannelController>().topChannelModelData.value =
            NewsTopChannelsModel.fromJson(map);
        Get.find<TopChannelController>().split = partition<Sources>(
            Get.find<TopChannelController>().topChannelModelData.value.sources!, 10);
        Get.find<TopChannelController>().fullPageCount =
            Get.find<TopChannelController>().split.length;
        Get.find<TopChannelController>().topNewsChannelData.value = Get.find<TopChannelController>()
            .split
            .elementAt(Get.find<TopChannelController>().position);
        Get.find<TopChannelController>().position =
            Get.find<TopChannelController>().position + 1;
        Get.find<TopChannelController>().isLoadingTopChannel(false);
      }

      ///no content available
      else if (response.statusCode == 204) {
        Get.find<TopChannelController>().topChannelModelData.value.sources = [];
        Get.find<TopChannelController>().isLoadingTopChannel(false);
      }
    } catch (error) {
      if (error is! Exception) {
        if (error.toString().contains("is not a subtype of")) {
          Get.find<TopChannelController>().topChannelModelData.value.error =
          'Type Error';
          Get.find<TopChannelController>().isLoadingTopChannel(false);
        }
      }
    }

    // do something before response
    return super.onResponse(response, handler); //add this line
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      if (err.type == DioErrorType.other &&
          err.error != null &&
          err.error is SocketException) {
        Get.find<TopChannelController>().isInternetAvailable(false);
        requestRetry!.scheduleRequestRetry(err.requestOptions).then((value) {
          print('!!!ConnectivityResult##########');
          Get.find<TopChannelController>().isInternetAvailable(true);
        });
      } else {
        String errorMessage = Exceptions.DioExceptions(err);
        Get.find<TopChannelController>().topChannelModelData.value.error =
            errorMessage;
        Get.find<TopChannelController>().isLoadingTopChannel(false);
        Get.find<TopChannelController>().isInternetAvailable(true);
      }
    } on FormatException catch (e) {
      Get.find<TopChannelController>().topChannelModelData.value.error =
      'Format exception';
      Get.find<TopChannelController>().isLoadingTopChannel(false);
      Get.find<TopChannelController>().isInternetAvailable(true);
    }

    return super.onError(err, handler);
  }
}

///Top news specific2
class TopNewsSpecificChannelInterceptor1 extends Interceptor {
  final DioConnectivityRequestRetry? requestRetry;

  TopNewsSpecificChannelInterceptor1({@required this.requestRetry,this.source});
  String? source;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('requesting#####');
    options.queryParameters={"apiKey": Keys.GET_NEWS_API_KEY, "sources": source};
    return super.onRequest(options, handler); //add this  //add this line
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {

    try {
      if (response.statusCode == 200) {
        print('responseData######${response.data}');
        final Map<String, dynamic> map =
        Map<String, dynamic>.from(response.data!);
        Get.find<TopChannelController>().specificSourceData.value =
            SpecificNewsModel.fromJson(map);
        Get.find<TopChannelController>().isLoadingNewsSpecificSource(false);
      }

      ///no content available
      else if (response.statusCode == 204) {
        Get.find<TopChannelController>().specificSourceData.value.articles = [];
        Get.find<TopChannelController>().isLoadingNewsSpecificSource(false);
      }
    } catch (error) {
      if (error is! Exception) {
        if (error.toString().contains("is not a subtype of")) {
          Get.find<TopChannelController>().specificSourceData.value.error =
          'Type Error';
          Get.find<TopChannelController>().isLoadingNewsSpecificSource(false);
        }
      }
    }
    return super.onResponse(response, handler); //add this line
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {

    try {
      if (err.type == DioErrorType.other &&
          err.error != null &&
          err.error is SocketException) {
        Get.find<TopChannelController>().isSourceInternetAvailable(false);
        requestRetry!.scheduleRequestRetry(err.requestOptions).then((value) {
          print('!!!ConnectivityResult##########');
          Get.find<TopChannelController>().isSourceInternetAvailable(true);
        });
      } else {
        String errorMessage = Exceptions.DioExceptions(err);
        Get.find<TopChannelController>().specificSourceData.value.error =
            errorMessage;
        Get.find<TopChannelController>().isLoadingNewsSpecificSource(false);
        Get.find<TopChannelController>().isSourceInternetAvailable(true);
      }
    } on FormatException catch (e) {
      Get.find<TopChannelController>().specificSourceData.value.error =
      'Format exception';
      Get.find<TopChannelController>().isLoadingNewsSpecificSource(false);
      Get.find<TopChannelController>().isSourceInternetAvailable(true);
    }

    return super.onError(err, handler);
  }

}


class AccountService extends Interceptor {
  static final _instance = AccountService._internal();

  AccountService._internal();

  static AccountService getInstance() {
    return _instance;
  }
}
