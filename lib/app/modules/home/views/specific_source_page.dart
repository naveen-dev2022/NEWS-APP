import 'dart:ui';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/home/controllers/home_controller.dart';
import 'package:getx_pattern/app/modules/home/models/top_channel_model.dart';
import 'package:getx_pattern/app/modules/home/widgets/specific_source_builder.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:sizer/sizer.dart';

class SpecificSource extends StatefulWidget {
  SpecificSource({Key? key, this.controller, this.data}) : super(key: key);

  HomeController? controller;
  Sources? data;

  @override
  State<SpecificSource> createState() => _SpecificSourceState(controller, data);
}

class _SpecificSourceState extends State<SpecificSource> {
  _SpecificSourceState(this.controller, this.data);

  HomeController? controller;
  Sources? data;

  @override
  void initState() {
    controller!.fetchTopNewsSpecificSourceData(data!.id);
    // TODO: implement initState
    super.initState();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>controller!.isSourceInternetAvailable.value?NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool isscrolled) {
            return <Widget>[
              SliverToBoxAdapter(child:SizedBox(height: 3.5.h,),),
              SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: MediaQuery.of(context).size.height / 3.2,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  topRight: Radius.circular(6.0)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/source_bg.jpg'),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: AssetImage(
                                        'assets/images/${data!.id}.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  AppWidgets.buildText(
                                    context: context,
                                    text: data!.name!,
                                    fontSize: 15,
                                    fontFamily: 'montserrat_bold',
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                       ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: AppWidgets.buildText(
                                          context: context,
                                          text: data!.category!,
                                          fontSize: 13,
                                          fontFamily: 'gotham_light',
                                          color: Theme.of(context).textTheme.headline2!.color),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            child: IconButton(
                              icon: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(50)),
                                  child:  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 15,
                                      color:Theme.of(context).iconTheme.color!,
                                    ),
                                  )),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      )),
                  pinned: true,
                  floating: true,
                  forceElevated: isscrolled,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50.0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SizedBox(
                            width: double.infinity,
                            child: AppWidgets.buildText(
                              context: context,
                              text: data!.name!,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'montserrat_bold',
                              fontSize: 18,
                              color: Theme.of(context).iconTheme.color
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ];
          },
          body: Container(
            height: 100.h,
            width: 100.w,
            child: Obx(
                  () => controller!.isLoadingNewsSpecificSource.value
                  ? ListViewSkeletonLoader(itemCount: 5,)
                  : SizedBox(
                height: 30.h,
                width: double.infinity,
                child: ListView.separated(
                  itemCount: controller!
                      .specificSourceData.value.articles!.length,
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12,),
                      child:  SpecificSourceBuilder(
                          data: controller!
                              .specificSourceData.value.articles![index]),
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                return  Divider(thickness: 0.6,);
                },
                ),
              ),
            ),
          )): InternetConnectionError()),
    );
  }
}
