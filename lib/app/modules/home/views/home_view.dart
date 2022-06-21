import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_pattern/app/modules/home/widgets/filter_country_list.dart';
import 'package:getx_pattern/app/modules/home/widgets/top_heading_builder.dart';
import 'package:getx_pattern/app/modules/home/widgets/top_news_builder.dart';
import 'package:getx_pattern/app/modules/login/controllers/login_controller.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:getx_pattern/core/values/utils/textfield.dart';
import 'package:sizer/sizer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final getStorage = GetStorage();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final user = FirebaseAuth.instance.currentUser;

  void _showBottomSheetForCountry(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.8,
                maxChildSize: 1,
                builder: (_, scrollcontroller) {
                  return CountryFilter(scrollcontroller: scrollcontroller);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => controller.isInternetAvailable.value
            ? Container(
                height: 100.h,
                width: 100.w,
                padding: EdgeInsets.only(left: 8, right: 8),
                child: ListView(
                  controller: controller.scrollController,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            controller.greetings,
                            style:  TextStyle(
                                fontSize: 22,
                                fontFamily: 'montserrat_bold',
                                foreground: Paint()..shader = LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurple.shade700,
                                    Theme.of(context).textTheme.headline2!.color!,
                                    //add more color here.
                                  ],
                                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                            )
                        ),
                        Get.find<LoginController>().isGuestMode.value?SizedBox():
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user!.photoURL!),
                            radius: 18.0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    controller.fetchedLocality.value != ''
                        ? controller.isLoading.value
                            ? GridViewSkeletonLoader(
                                itemCount: 1,
                                itemsPerRow: 1,
                                childAspectRatio: 1.5,
                              )
                            : controller.weatherModelData.value.error == null
                                ? Card(
                                    shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Container(
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).iconTheme.color,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  AppWidgets.buildText(
                                                      context: context,
                                                      text: controller
                                                          .weatherModelData
                                                          .value
                                                          .weather![0]
                                                          .main,
                                                      fontSize: 20,
                                                      fontFamily: 'gotham_bold',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  AppWidgets.buildText(
                                                      context: context,
                                                      text: controller
                                                          .weatherModelData
                                                          .value
                                                          .weather![0]
                                                          .description,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'montserrat_light',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ],
                                              ),
                                              SizedBox(width: 25.w),
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  AppWidgets.buildText(
                                                      context: context,
                                                      text: controller
                                                          .currentDate,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'montserrat_regular',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 2.w),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 60),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${(controller.weatherModelData.value.main!.temp)?.floor()}',
                                                    ),
                                                    WidgetSpan(
                                                      child:
                                                          Transform.translate(
                                                        offset: const Offset(
                                                            0.0, -40.0),
                                                        child: Text(
                                                          '°C',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Image.asset(
                                                controller.ChooseImageUrl(
                                                    controller.weatherModelData
                                                        .value.weather![0].main!
                                                        .toLowerCase()),
                                                height: 100,
                                                width: 200,
                                                fit: BoxFit.cover,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10),
                                              Icon(Icons.location_on_outlined,size: 20,),
                                              AppWidgets.buildText(
                                                  context: context,
                                                  text:
                                                      '${controller.weatherModelData.value.name},',
                                                  fontSize: 15,
                                                  fontFamily:
                                                      'montserrat_medium',
                                                  fontWeight: FontWeight.w500),
                                              AppWidgets.buildText(
                                                  context: context,
                                                  text: controller
                                                      .weatherModelData
                                                      .value
                                                      .sys!
                                                      .country,
                                                  fontSize: 15,
                                                  fontFamily:
                                                      'montserrat_medium',
                                                  fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 16),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  border: Border.all(
                                                      color: Colors
                                                          .white70, // set border color
                                                      width:
                                                          1.0), // set border width
                                                  borderRadius: BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8.0),
                                                      bottomRight:
                                                          Radius.circular(8.0),
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                      bottomLeft:
                                                          Radius.circular(8.0)),
                                                ),
                                                height: 40,
                                                width: 85.w,
                                                child: CustomTextField(
                                                  topLeft: 8,
                                                  topRight: 8,
                                                  bottomRight: 8,
                                                  bottomLeft: 8,
                                                  color: Theme.of(context).iconTheme.color,
                                                  hint: 'search a place',
                                                  prefixColor: Colors.white,
                                                  sufixColor: Colors.white,
                                                  textEditingController:
                                                      controller.weatherController
                                                          .value,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  icon: Icons.search_rounded,
                                                  paddingTop: 2.0,
                                                  issufixIcon: true,
                                                  onChanged: (value) {},
                                                  onPressed: () {
                                                    if (controller
                                                        .weatherController
                                                        .value
                                                        .text
                                                        .isEmpty) {
                                                      AppMethods.showSnackBar(
                                                          context,
                                                          'Please enter any place',
                                                          Theme.of(context).iconTheme.color);
                                                    } else {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      controller.fetchWeatherData(
                                                          controller
                                                              .weatherController
                                                              .value
                                                              .text);
                                                      controller.weatherController
                                                          .value.text = '';
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ErrorMessage(
                                    errorMessage:
                                        controller.weatherModelData.value.error,
                                    onPressed: () {
                                      controller.fetchWeatherData(
                                          controller.fetchedLocality.value);
                                    },
                                  )
                        : GestureDetector(
                            onTap: () {
                              controller.determinePosition();
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:Stack(children: [
                                Image.asset(
                                  'assets/images/enable_location1.png.webp',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  color: Color(0xff121212).withOpacity(0.8),
                                  colorBlendMode: BlendMode.softLight,
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: 200,
                                    width: 100.w,
                                    padding: EdgeInsets.only(left: 5),
                                    color: Colors.black38,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AppWidgets.buildText(
                                            context: context,
                                            maxline: 2,
                                            text: 'Tap to enable your location',
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'montserrat_bold',
                                            fontSize: 18,
                                            textAlign: TextAlign.center,
                                            color: Colors.white),
                                        SizedBox(height: 6,),
                                        AppWidgets.buildText(
                                            context: context,
                                            maxline: 2,
                                            text: "You'll need to enable your location in order to\nget your current weather ",
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'poppins_regular',
                                            fontSize: 11,
                                            textAlign: TextAlign.center,
                                            color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ],)
                            ),
                          ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: AppWidgets.buildText(
                        context: context,
                        text: 'Top Channels',
                        fontSize: 18,
                        fontFamily: 'montserrat_bold',
                        color: Theme.of(context).iconTheme.color
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    controller.isLoadingTopChannel.value
                        ? TopChannelSkeletonLoader(
                            itemCount: 1,
                          )
                        : controller.topNewChannelModelData.value.error == null
                            ? SizedBox(
                                height: 15.h,
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount: 8,
                                  addAutomaticKeepAlives: true,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TopNewsBuilder(
                                        data: controller.topNewChannelModelData
                                            .value.sources![index],
                                        controller: controller);
                                  },
                                ),
                              )
                            : ErrorMessage(
                                errorMessage: controller
                                    .topNewChannelModelData.value.error,
                                onPressed: () {
                                  controller.fetchTopNewsChannelData();
                                },
                              ),
                    SizedBox(
                      width: 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppWidgets.buildText(
                            context: context,
                            text: 'Top Headings',
                            fontSize: 18,
                            fontFamily: 'montserrat_bold',
                            color:Theme.of(context).iconTheme.color
                          ),
                          IconButton(
                              onPressed: () {
                                _showBottomSheetForCountry(context);
                              },
                              icon: Icon(
                                Icons.notes,
                                size: 35,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    controller.isLoadingTopHeading.value
                        ? GridViewSkeletonLoader(
                            itemCount: 5,
                            itemsPerRow: 1,
                            childAspectRatio: 1.8,
                          )
                        : controller.topHeadingModelData.value.error == null
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.articles.length,
                                addAutomaticKeepAlives: true,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return TopHeadingBuilder(
                                    data: controller.articles[index],
                                  );
                                },
                              )
                            : ErrorMessage(
                                errorMessage:
                                    controller.topHeadingModelData.value.error,
                                onPressed: () {
                                  controller.fetchTopNewsHeadingData('us');
                                },
                              ),
                    SizedBox(
                      height: 1.h,
                    ),
                    controller.isPaginationLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox()
                  ],
                ),
              )
            : InternetConnectionError()));
  }
}
