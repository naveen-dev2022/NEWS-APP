import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/data/providers/dio_connectivity_request_retrier.dart';
import 'package:getx_pattern/app/data/providers/interceptors.dart';
import 'package:getx_pattern/app/modules/home/models/specific_news_model.dart'
    as source;
import 'package:getx_pattern/app/modules/home/models/top_channel_model.dart';
import 'package:getx_pattern/app/modules/home/models/weather_model.dart';
import 'package:getx_pattern/app/modules/search/model/articals_common_model.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  var isLoading = false.obs;
  var isLoadingTopChannel = false.obs;
  var isLoadingNewsSpecificSource = false.obs;
  Rx<TextEditingController> weatherController = TextEditingController().obs;
  var weatherModelData = WeatherModel().obs;
  var topNewChannelModelData = NewsTopChannelsModel().obs;
  String weatherIconDr = '';
  var specificSourceData = source.SpecificNewsModel().obs;
  double? _scrollThreshold = 170.0;
  RxBool isInternetAvailable = true.obs;
  RxBool isSourceInternetAvailable = true.obs;
  String greetings = '';
  DateTime now = DateTime.now();
  String? currentDate = '';
  final _dayNameFormatter = DateFormat('EEE');
  final _monthFormatter = DateFormat('MMM');
  RxString fetchedLocality=''.obs;

  var countryList = [
    {
      "image": "https://newsapi.org/images/flags/ar.svg",
      "country": "Argentina",
      "code": "ar"
    },
    {
      "image": "https://newsapi.org/images/flags/au.svg",
      "country": "Australia",
      "code": "au"
    },
    {
      "image": "https://newsapi.org/images/flags/at.svg",
      "country": "Austria",
      "code": "at"
    },
    {
      "image": "https://newsapi.org/images/flags/br.svg",
      "country": "Brazil",
      "code": "br"
    },
    {
      "image": "https://newsapi.org/images/flags/ca.svg",
      "country": "Canada",
      "code": "ca"
    },
    {
      "image": "https://newsapi.org/images/flags/cn.svg",
      "country": "China",
      "code": "cn"
    },
    {
      "image": "https://newsapi.org/images/flags/co.svg",
      "country": "Colombia",
      "code": "co"
    },
    {
      "image": "https://newsapi.org/images/flags/cu.svg",
      "country": "Cuba",
      "code": "cu"
    },
    {
      "image": "https://newsapi.org/images/flags/eg.svg",
      "country": "Egypt",
      "code": "eg"
    },
    {
      "image": "https://newsapi.org/images/flags/fr.svg",
      "country": "France",
      "code": "fr"
    },
    {
      "image": "https://newsapi.org/images/flags/de.svg",
      "country": "Germany",
      "code": "de"
    },
    {
      "image": "https://newsapi.org/images/flags/hk.svg",
      "country": "Hong Kong",
      "code": "hk"
    },
    {
      "image": "https://newsapi.org/images/flags/hu.svg",
      "country": "Hungary",
      "code": "hu"
    },
    {
      "image": "https://newsapi.org/images/flags/in.svg",
      "country": "india",
      "code": "in"
    },
    {
      "image": "https://newsapi.org/images/flags/il.svg",
      "country": "Israel",
      "code": "il"
    },
    {
      "image": "https://newsapi.org/images/flags/it.svg",
      "country": "Italy",
      "code": "it"
    },
    {
      "image": "https://newsapi.org/images/flags/jp.svg",
      "country": "Japan",
      "code": "jp"
    },
    {
      "image": "https://newsapi.org/images/flags/my.svg",
      "country": "Malaysia",
      "code": "my"
    },
    {
      "image": "https://newsapi.org/images/flags/mx.svg",
      "country": "Mexico",
      "code": "mx"
    },
    {
      "image": "https://newsapi.org/images/flags/nz.svg",
      "country": "New Zealand",
      "code": "nz"
    },
    {
      "image": "https://newsapi.org/images/flags/ph.svg",
      "country": "Philippines",
      "code": "ph"
    },
    {
      "image": "https://newsapi.org/images/flags/ro.svg",
      "country": "Romania",
      "code": "ro"
    },
    {
      "image": "https://newsapi.org/images/flags/ru.svg",
      "country": "Russia",
      "code": "ru"
    },
    {
      "image": "https://newsapi.org/images/flags/sa.svg",
      "country": "Saudi Arabia",
      "code": "sa"
    },
    {
      "image": "https://newsapi.org/images/flags/sg.svg",
      "country": "Singapore",
      "code": "sg"
    },
    {
      "image": "https://newsapi.org/images/flags/za.svg",
      "country": "South Africa",
      "code": "za"
    },
    {
      "image": "https://newsapi.org/images/flags/ch.svg",
      "country": "Switzerland",
      "code": "ch"
    },
    {
      "image": "https://newsapi.org/images/flags/th.svg",
      "country": "Thailand",
      "code": "th"
    },
    {
      "image": "https://newsapi.org/images/flags/ae.svg",
      "country": "UAE",
      "code": "ae"
    },
    {
      "image": "https://newsapi.org/images/flags/ua.svg",
      "country": "Ukraine",
      "code": "ua"
    },
    {
      "image": "https://newsapi.org/images/flags/gb.svg",
      "country": "United Kingdom",
      "code": "gb"
    },
    {
      "image": "https://newsapi.org/images/flags/us.svg",
      "country": "United States",
      "code": "us"
    },
  ];

  List<String> weatherIcon = [
    'assets/images/clear_sky.png',
    'assets/images/broken_clouds.png',
    'assets/images/shower_rain.png',
    'assets/images/rain.png',
    'assets/images/thunderstrom.png',
    'assets/images/snow.png',
    'assets/images/mist.png',
  ];

  String ChooseImageUrl(String? data) {
    print('ChooseImageUrl---->>>${data}');
    switch (GetUtils.removeAllWhitespace(data!)) {
      case 'clear': /////
        {
          return weatherIcon[0];
        }

      case 'clouds': ////
        {
          return weatherIcon[1];
        }

      case 'drizzle': ////
        {
          return weatherIcon[2];
        }

      case 'rain': ////
        {
          return weatherIcon[3];
        }

      case 'thunderstorm': /////
        {
          return weatherIcon[4];
        }

      case 'snow': ////
        {
          return weatherIcon[5];
        }

      default:
        {
          return weatherIcon[6];
        }
    }
  }

  ///pagination code here

  int? fullPageCount;
  int position = 0;
  Iterable<List<Articles>> split = [];
  RxList<Articles> articles = <Articles>[].obs;
  ScrollController scrollController = ScrollController();
  var isLoadingTopHeading = false.obs;
  var isPaginationLoading = false.obs;
  var topHeadingModelData = ArticlesCommonModel().obs;

  ///#######

  void greeting() {
    var hour = now.hour;
    if (hour < 12) {
      greetings = 'Good Morning';
    } else if (hour < 17) {
      greetings = 'Good Afternoon';
    } else {
      greetings = 'Good Evening';
    }
  }

  void GetDateFormat() {
    currentDate =
        '${_dayNameFormatter.format(now)},${_monthFormatter.format(now)} ${now.day}';
  }

  @override
  void onInit() {
  //  determinePosition();
    greeting();
    GetDateFormat();
    fetchTopNewsChannelData();
    fetchTopNewsHeadingData('us');
    super.onInit();
  }

 /* Future getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print('#####----->>>>location.enabled');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('#####----->>>>location.enabled22222');
        return;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      print('#####----->>>>PermissionStatus.denied');
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('#####----->>>>PermissionStatus.granted');
        return;
      }
    }

    _currentPosition = await location.getLocation();

    StreamSubscription? streamSubscription;

    streamSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
          if(currentLocation.latitude!=null){
            streamSubscription!.cancel();
            isLoading(true);
            print('#####----->>>>onLocationChanged');

          }
    });

  }*/

  Future determinePosition() async {
    bool? serviceEnabled;
    LocationPermission? permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppMethods.toastMsg('Please enable Your Location Service');
    }else{
      print('Location enabled');
      fetchedLocality.value='Chennai';
      isLoading(true);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppMethods.toastMsg('Location permissions are permanently denied, we cannot request permissions.');
      await  openAppSettings();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude/*10.557516,77.579386*/);

      Placemark place = placemarks[0];
      fetchedLocality.value = place.subAdministrativeArea!;
      fetchWeatherData(place.subAdministrativeArea);

    } catch (e) {
      print('%%%%%%%%%%$e');
    }
  }

  addItems() async {
    scrollController.addListener(() {
      if ((scrollController.position.maxScrollExtent -
                  scrollController.position.pixels) <=
              _scrollThreshold! &&
          !isPaginationLoading.value) {
        print('%%%%%%%%%%%%%%%%%%%%');
        if (position < fullPageCount!) {
          isPaginationLoading(true);
          Future.delayed(Duration(milliseconds: 1000), () {
            print('Future.delayed-----');
          }).then((value) {
            articles.addAll(split.elementAt(position));
            position = position + 1;
            isPaginationLoading(false);
          });
        }
      }
    });
  }

  @override
  void onReady() {
    addItems();
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> fetchWeatherData(String? place) async {
    Dio? dio = Dio();

    dio.interceptors.add(
      weatherInterceptor(
        place: place,
        requestRetry: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    isLoading(true);

    await dio.get<Map<String, dynamic>>(
      '${Keys.GET_WEATHER_BASEURL_KEY}',
    );
  }

  Future<void> fetchTopNewsChannelData() async {
    Dio? dio = Dio();

    dio.interceptors.add(
      TopNewsChannelInterceptor(
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
      TopNewsSpecificChannelInterceptor(
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

  Future<void> fetchTopNewsHeadingData(String? country) async {
    Dio? dio = Dio();

    dio.interceptors.add(
      TopHeadingInterceptor(
        country: country,
        requestRetry: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    isLoadingTopHeading(true);

    await dio.get<Map<String, dynamic>>(
        '${Keys.GET_NEWS_BASEURL_KEY}/top-headlines');
  }
}
