import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/home/controllers/home_controller.dart';
import 'package:getx_pattern/app/modules/home/models/top_channel_model.dart';
import 'package:getx_pattern/app/modules/home/views/specific_source_page.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';

class TopNewsBuilder extends StatelessWidget {
  TopNewsBuilder({Key? key, this.data,this.controller}) : super(key: key);

  Sources? data;
  HomeController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          OpenContainer(
            transitionDuration:
            Duration(milliseconds: 650),
            openBuilder: (context, _) =>
                SpecificSource(
                    controller: controller,
                    data: data),
            closedBuilder: (context,
                openContainer) =>
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage(
                    'assets/images/${data!.id}.png',
                  ),
                ),
            closedColor:
            Theme.of(context).primaryColor,
            transitionType: ContainerTransitionType.fade,
            closedShape: CircleBorder(),
            openShape: RoundedRectangleBorder(),
            openElevation: 0.0,
            closedElevation: 8.0,
          ),
          SizedBox(height: 16.0),
          AppWidgets.buildText(
            context: context,
            text: data!.name!,
            fontSize: 13.5,
            fontFamily: 'avenir_roman',
          ),
          SizedBox(height: 5.0),
          AppWidgets.buildText(
              context: context,
              text: data!.category!,
              fontSize: 11.5,
              fontFamily: 'gotham_light',
            color: Theme.of(context).textTheme.headline2!.color),
        ],
      ),
    );
  }
}
