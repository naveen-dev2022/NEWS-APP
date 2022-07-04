import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/modules/bookmark/model/articals_common_model.dart';
import 'package:getx_pattern/core/values/theme/themes_service.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';

class BookmarkController extends GetxController {
  //TODO: Implement HomeController

  final getStorage = GetStorage();

  RxList SavedArticle = [].obs;

  RxBool appTheme=false.obs;

  @override
  void onInit() {
    appTheme.value=ThemeService().isSavedDarkMode();
    getBookmarkedData();
    super.onInit();
  }

  @override
  void onReady() {

    super.onReady();
  }

  @override
  void onClose() {}

  void getBookmarkedData()  {

    if(getStorage.read(Keys.BOOKMARK_ARTICLES)==null){
      SavedArticle.value=[];
    }
    else{
      print('storage@@@@@@@@${getStorage.read(Keys.BOOKMARK_ARTICLES)}');
      final favoriteList = getStorage.read(Keys.BOOKMARK_ARTICLES);
      var decodeList = jsonDecode(favoriteList) as List;
      SavedArticle.value = decodeList.map((e) => Favorite.fromJson(e)).toList();
    }

  }


}
