import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:getx_pattern/app/modules/channels/controllers/top_channel_controller.dart';
import 'package:getx_pattern/app/modules/channels/views/specific_source_page.dart';
import 'package:getx_pattern/app/modules/home/models/top_channel_model.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';

class TopChannelSourceBuilder extends StatelessWidget {
   TopChannelSourceBuilder({Key? key,this.data,this.controller}) : super(key: key);

  Sources? data;
  TopChannelController? controller;

  @override
  Widget build(BuildContext context) {
    return  OpenContainer(
      transitionDuration:
      Duration(milliseconds: 650),
      openBuilder: (context, _) =>
          SpecificSource(
              controller: controller,
              data: data),
      closedBuilder: (context,
          openContainer) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(30.0),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage(
                    'assets/images/${data!.id}.png',
                  ),
                ),
              ),
              SizedBox(height: 8.0),
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
                  color: Theme.of(context).textTheme.headline3!.color),
            ],
          ),
      closedColor:
      Theme.of(context).textTheme.headline4!.color!,
      transitionType: ContainerTransitionType.fade,
      openShape: RoundedRectangleBorder(),
      openElevation: 0.0,
      closedElevation: 2.0,
    );
  }
}
