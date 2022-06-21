import 'package:flutter/material.dart';

class Themes {
  final LightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primaryColor: Colors.white,
    // backgroundColor: Color(0xffcfc0f8),
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.deepPurpleAccent, opacity: 0.8),
    indicatorColor: Colors.deepPurpleAccent,
    appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurpleAccent),
    textTheme: TextTheme(
      headline1: TextStyle(color: Color(0xff121212)),
      headline2: TextStyle(color: Color(0xf89386f8)),
      headline3: TextStyle(color: Color(0xf8bbb3fa)),
      headline4: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Color(0xff121212)),
      subtitle1: TextStyle(color: Color(0xff121212)),
    ),
  );

  final DarkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xff121212),
      brightness: Brightness.dark,
      primaryColor: Color(0xff121212),
      colorScheme: ColorScheme.dark(),
      iconTheme:
          IconThemeData(color: Colors.deepPurpleAccent.shade100, opacity: 0.8),
      indicatorColor: Colors.deepPurpleAccent.shade100,
      appBarTheme:
          AppBarTheme(backgroundColor: Colors.deepPurpleAccent.shade100),
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.white),
      headline2: TextStyle(color: Color(0xffc2a3f8)),
      headline3: TextStyle(color: Color(0xffd9c5fc)),
      headline4: TextStyle(color: Color(0xff343434)),
      bodyText2: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
    ),
  );

}
