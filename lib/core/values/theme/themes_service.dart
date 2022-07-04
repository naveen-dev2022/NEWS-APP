import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/modules/bookmark/controllers/bookmark_controller.dart';
import 'package:getx_pattern/core/values/utils/keys.dart';

class ThemeService{
  final _getStorage=GetStorage();
  
  ThemeMode getThemeMode(){
    return isSavedDarkMode()?ThemeMode.dark:ThemeMode.light;
  }
  
  bool isSavedDarkMode(){
    return _getStorage.read(Keys.THEME_STATUS_KEY)??false;
  }
  
  void saveThemeMode(bool isDarkMode){
    Get.find<BookmarkController>().appTheme.value=isDarkMode;
    _getStorage.write(Keys.THEME_STATUS_KEY, isDarkMode);
  }
  
  void changeThemeMode(){
    Get.changeThemeMode(isSavedDarkMode()?ThemeMode.light:ThemeMode.dark);
    saveThemeMode(!isSavedDarkMode());
  }
  
}