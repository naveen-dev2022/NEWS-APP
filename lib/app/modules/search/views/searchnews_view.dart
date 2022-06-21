import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/home/widgets/top_heading_builder.dart';
import 'package:getx_pattern/app/modules/search/controllers/searchnews_controller.dart';
import 'package:getx_pattern/core/values/utils/helpers.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:getx_pattern/core/values/utils/textfield.dart';
import 'package:sizer/sizer.dart';

class SearchNewsView extends GetView<SearchNewsController> {
  SearchNewsView({Key? key}) : super(key: key);

  DateTime selectedDate = DateTime.now();
  String? fromDate;
  String? toDate;
  String? validateFilters = '';
  bool isApplyPressed = false;

  void _showBottomSheetFilterArticles(BuildContext context) {
    if (!isApplyPressed) {
      fromDate = 'FromDate';
      toDate = 'ToDate';
      controller.languageBGColorList =
          RxList.filled(controller.countryCode.length, false, growable: false);
      controller.sortByBGColorList =
          RxList.filled(controller.sortBy.length, false, growable: false);
    }

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
                  return StatefulBuilder(
                      builder: (BuildContext context, setter) {
                    return Container(
                      width: 100.w,
                      height: 100.h,
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: AppWidgets.buildText(
                                  context: context,
                                    text: 'Filters',
                                    fontSize: 16,
                                    fontFamily: 'montserrat_bold'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 100.w,
                            child: AppWidgets.buildText(
                                context: context,
                                text: 'Select Date',
                                fontSize: 16,
                                fontFamily: 'montserrat_medium',
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    _selectDateFrom(context, setter),
                                // Refer step 3
                                child: Container(
                                  height: 35,
                                  width: 42.w,
                                  color: Theme.of(context).textTheme.headline3!.color!,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${fromDate ?? 'From'}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontFamily: 'quicksand_regular'),
                                      ),
                                      Icon((Icons.arrow_drop_down_outlined))
                                    ],
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _selectDateTo(context, setter),
                                // Refer step 3
                                child: Container(
                                  height: 35,
                                  width: 42.w,
                                  color: Theme.of(context).textTheme.headline3!.color!,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '${toDate ?? 'To'}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontFamily: 'quicksand_regular'),
                                      ),
                                      Icon((Icons.arrow_drop_down_outlined))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 100.w,
                            child: AppWidgets.buildText(
                                context: context,
                                text: 'Language',
                                fontSize: 16,
                                fontFamily: 'montserrat_medium',
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          GridView.builder(
                            // controller: scrollcontroller,
                            //kill scrollable,
                            shrinkWrap: true,
                            itemCount: controller.countryCode.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2, crossAxisCount: 4),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setter(() {
                                      controller.languageBGColorList =
                                          RxList.filled(
                                              controller
                                                  .languageBGColorList.length,
                                              false,
                                              growable: true);
                                      controller.languageBGColorList[index] =
                                          true;
                                      controller.languageValue.value =
                                          controller.countryCode[index]
                                              ['code']!;
                                      validateFilters = controller
                                          .countryCode[index]['code']!;
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 120,
                                    color:
                                        !controller.languageBGColorList[index]
                                            ? Theme.of(context).textTheme.headline3!.color!
                                            : Colors.deepPurpleAccent,
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: AppWidgets.buildText(
                                          context: context,
                                          text: controller.countryCode[index]
                                              ['language'],
                                          fontFamily: 'quicksand_regular',
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 100.w,
                            child: AppWidgets.buildText(
                                context: context,
                                text: 'SortBy',
                                fontSize: 16,
                                fontFamily: 'montserrat_medium',
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          GridView.builder(
                            // controller: scrollcontroller,
                            //kill scrollable,
                            shrinkWrap: true,
                            itemCount: controller.sortBy.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2.5, crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setter(() {
                                      controller.sortByBGColorList =
                                          RxList.filled(
                                              controller.sortBy.length, false,
                                              growable: true);
                                      controller.sortByBGColorList[index] =
                                          true;
                                      controller.sortByValue.value =
                                          controller.sortBy[index]['key']!;
                                      validateFilters =
                                          controller.sortBy[index]['key']!;
                                    });
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: !controller
                                                    .sortByBGColorList[index]
                                                ? Theme.of(context).textTheme.headline3!.color!
                                                : Colors.deepPurpleAccent,
                                            width: 2),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: Column(
                                      children: [
                                        AppWidgets.buildText(
                                            context: context,
                                            text: controller.sortBy[index]
                                                ['key'],
                                            fontSize: 13,
                                            fontFamily: 'quicksand_regular'),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        AppWidgets.buildText(
                                            context: context,
                                            text: controller.sortBy[index]
                                                ['disc'],
                                            fontSize: 10,
                                            textAlign: TextAlign.center,
                                            fontFamily: 'gotham_thin',
                                          color: Theme.of(context).textTheme.headline3!.color
                                            ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          TextButton(
                              onPressed: () {
                                if (validateFilters != '') {
                                  isApplyPressed = true;
                                  controller.fetchSearchNewsData(
                                      controller.searchNewsController.value
                                                  .text ==
                                              ''
                                          ? 'apple'
                                          : controller
                                              .searchNewsController.value.text,
                                      controller.fromDateValue.value,
                                      controller.toDateValue.value,
                                      controller.languageValue.value,
                                      controller.sortByValue.value);
                                  Navigator.pop(context);
                                } else {
                                  isApplyPressed = true;
                                  AppMethods.GetxSnackBar(
                                      'Please choose any filters');
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).iconTheme.color!,
                                    borderRadius: BorderRadius.circular(6)),
                                height: 30,
                                width: 100,
                                child: Center(
                                    child: AppWidgets.buildText(
                                        context: context,
                                        text: 'Apply',fontSize: 14)),
                              ))
                        ],
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  _selectDateFrom(BuildContext context, setter) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      print('picked----$picked');
      setter(() {
        fromDate = '${picked.year}-${picked.month}-${picked.day}';
        controller.fromDateValue.value = fromDate!;
        validateFilters = fromDate;
      });
    }
  }

  _selectDateTo(BuildContext context, setter) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      print('picked----$picked');
      setter(() {
        toDate = '${picked.year}-${picked.month}-${picked.day}';
        controller.toDateValue.value = toDate!;
        validateFilters = toDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isInternetAvailable.value
          ? Container(
              height: 100.h,
              width: double.infinity,
              padding: EdgeInsets.only(left: 8, right: 8),
              child: ListView(
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 80.w,
                        child: CustomTextField(
                          prefixColor: Colors.white,
                          sufixColor: Colors.white,
                          topLeft: 20,
                          topRight: 20,
                          bottomRight: 20,
                          bottomLeft: 20,
                          color: Theme.of(context).iconTheme.color,
                          hint: 'search any word',
                          textEditingController:
                              controller.searchNewsController.value,
                          keyboardType: TextInputType.text,
                          icon: Icons.search_rounded,
                          paddingTop: 4.0,
                          issufixIcon: true,
                          onChanged: (value) {},
                          onPressed: () {
                            if (controller
                                .searchNewsController.value.text.isEmpty) {
                              AppMethods.showSnackBar(
                                  context, 'Please enter any word', Theme.of(context).iconTheme.color);
                            } else {
                              FocusScope.of(context).unfocus();
                              controller.fetchSearchNewsData(
                                  controller.searchNewsController.value.text ==
                                          ''
                                      ? 'apple'
                                      : controller
                                          .searchNewsController.value.text,
                                  controller.fromDateValue.value,
                                  controller.toDateValue.value,
                                  controller.languageValue.value,
                                  controller.sortByValue.value);
                            }
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            _showBottomSheetFilterArticles(context);
                            //   AppMethods.GetxDialog(errMsg)
                          },
                          icon: Icon(
                            Icons.notes,
                            size: 35,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  controller.isLoadingSearchNews.value
                      ? GridViewSkeletonLoader(
                          itemCount: 6,
                          itemsPerRow: 1,
                          childAspectRatio: 1.8,
                        )
                      : controller.searchNewsData.value.error == null
                          ? SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller
                                    .searchNewsData.value.articles!.length,
                                addAutomaticKeepAlives: true,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return TopHeadingBuilder(
                                    data: controller
                                        .searchNewsData.value.articles![index],
                                  );
                                },
                              ),
                            )
                          : ErrorMessage(
                              errorMessage:
                                  controller.searchNewsData.value.error,
                              onPressed: () {
                                controller.fetchSearchNewsData(
                                    controller.searchNewsController.value
                                                .text ==
                                            ''
                                        ? 'apple'
                                        : controller
                                            .searchNewsController.value.text,
                                    controller.fromDateValue.value,
                                    controller.toDateValue.value,
                                    controller.languageValue.value,
                                    controller.sortByValue.value);
                              },
                            ),
                ],
              ),
            )
          : InternetConnectionError()),
    );
  }
}
