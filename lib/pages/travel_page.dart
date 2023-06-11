import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_travel/dao/travel_tab.dart';
import 'package:flutter_travel/model/travel_tab_model.dart';
import 'package:flutter_travel/pages/travel_tab_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../pic/instagram_filter_selection.dart';
import '../util/navigator_util.dart';
import '../video_clip/clipper_view.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  late TabController _controller;
  List<TravelTab> tabs = [];
  late TravelTabModel travelTabModel;
  late File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      _controller = TabController(
          length: model.tabs.length, vsync: this); //fix tab label 空白问题
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.absolute);
      } else {
        print('No video selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: TabBar(
                controller: _controller,
                isScrollable: true,
                labelColor: Colors.black,
                labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                indicator: UnderlineIndicator(
                    strokeCap: StrokeCap.round,
                    borderSide: BorderSide(
                      color: Color(0xff2fcfbb),
                      width: 3,
                    ),
                    insets: EdgeInsets.only(bottom: 10)),
                tabs: tabs.map<Tab>((TravelTab tab) {
                  return Tab(
                    text: tab.labelName,
                  );
                }).toList()),
          ),
          Flexible(
              child: TabBarView(
                  controller: _controller,
                  children: tabs.map((TravelTab tab) {
                    return TravelTabPage(
                      travelUrl: travelTabModel.url,
                      params: travelTabModel.params,
                      groupChannelCode: tab.groupChannelCode,
                    );
                  }).toList()))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: Colors.black12)),
                        ),
                        height: 80,
                        width: 750,
                        child: new InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            NavigatorUtil.push(
                                context, ExampleInstagramFilterSelection());
                          },
                          child: new Center(
                            child: new Text(
                              '为照片添加滤镜',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0, color: Colors.black12)),
                        ),
                        height: 80,
                        width: 750,
                        child: new InkWell(
                          onTap: () {
                            getVideo();
                          },
                          child: new Center(
                            child: new Text(
                              '拍摄视频',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 750,
                        child: InkWell(
                          onTap: () async {
                            // Navigator.pop(context);
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.video,
                              allowCompression: false,
                            );
                            if (result != null) {
                              File file = File(result.files.single.path!);
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return ClipperView(file);
                                }),
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              '剪辑视频',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
