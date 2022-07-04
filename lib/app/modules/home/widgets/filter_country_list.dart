import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_pattern/app/modules/home/controllers/home_controller.dart';
import 'package:getx_pattern/core/values/utils/reusable_components.dart';
import 'package:getx_pattern/core/values/utils/textfield.dart';
import 'package:sizer/sizer.dart';
import 'package:substring_highlight/substring_highlight.dart';

class CountryFilter extends StatefulWidget {
  CountryFilter({Key? key,this.scrollcontroller}) : super(key: key);

  ScrollController? scrollcontroller;
  @override
  _CountryFilterState createState() => new _CountryFilterState();
}

class _CountryFilterState extends State<CountryFilter> {
  var controller = Get.find<HomeController>();
  TextEditingController editingController = TextEditingController();

  List<Map<String, String>>? duplicateItems;
  List<Map<String, String>> items = [];

  @override
  void initState() {
    duplicateItems = controller.countryList;
    items.addAll(duplicateItems!);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<Map<String, String>>? dummySearchList = [];
    dummySearchList.addAll(duplicateItems!);
    if (query.isNotEmpty) {
      List<Map<String, String>>? dummyListData = [];
      dummySearchList.forEach((item) {
        if (item['country']!.camelCase!.contains(query.camelCase!)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Center(
                  child:
                      AppWidgets.buildText( context: context,text: 'Country list', fontSize: 15)),
            ),
            SizedBox(
              height: 2.h,
            ),
            CustomTextField(
              topLeft: 10,
              topRight: 10,
              bottomRight: 10,
              bottomLeft: 10,
              color: Colors.deepPurpleAccent.shade100,
              hint: 'search country',
              textEditingController: editingController,
              keyboardType: TextInputType.text,
              icon: Icons.search_rounded,
              paddingTop: 13.0,
              issufixIcon: false,
              onChanged: (value) {
                filterSearchResults(value);
              },
              onPressed: () {},
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                controller: widget.scrollcontroller,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.fullPageCount=null;
                      controller.position = 0;
                      controller.split = [];
                      controller.fetchTopNewsHeadingData(items[index]['code']);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Row(
                        children: [
                          ClipRRect(
                              child: SvgPicture.network(
                                '${items[index]['image']}',
                                fit: BoxFit.fill,
                                height: 50,
                                width: 50,
                                placeholderBuilder: (BuildContext context) =>
                                    Center(
                                  child: SpinKitRipple(
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(50)),
                          SizedBox(
                            width: 12,
                          ),
                          SubstringHighlight(
                            caseSensitive: false,
                            text: items[index]['country']!,
                            // each string needing highlighting
                            term: editingController.value.text,
                            // user typed "m4a"
                            textStyle: TextStyle(
                              // non-highlight style
                              color: Colors.grey.shade700,
                              fontSize: 13
                            ),
                            textStyleHighlight: const TextStyle(
                              // highlight style
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
