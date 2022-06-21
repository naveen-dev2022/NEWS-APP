import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:getx_pattern/app/modules/home/views/home_view.dart';
import 'package:getx_pattern/app/modules/search/views/searchnews_view.dart';
import 'bookmark/views/bookmark_view.dart';
import 'channels/views/top_channel_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget>? _children;
  int _currentIndex = 0;

  @override
  void initState() {
    _children = [
      HomeView(),
      SearchNewsView(),
      TopNewsChannel(),
      BookmarkView()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).primaryColor,
        height: 50,
        backgroundColor: Color(0xf8c6beff),
        items: <Widget>[
          Icon(Icons.home_outlined, size: 25),
          Icon(Icons.search, size: 25),
          Icon(Icons.airplay_outlined, size: 25),
          Icon(Icons.person_outline, size: 25),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _children!.elementAt(_currentIndex),
    );
  }
}
