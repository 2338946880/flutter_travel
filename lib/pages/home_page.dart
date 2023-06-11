import 'package:flutter/material.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_travel/dao/home.dart';
import 'package:flutter_travel/model/common_model.dart';
import 'package:flutter_travel/model/config_model.dart';
import 'package:flutter_travel/model/grid_nav_model.dart';
import 'package:flutter_travel/model/home_model.dart';
import 'package:flutter_travel/model/sales_box_model.dart';
import 'package:flutter_travel/pages/search_page.dart';
import 'package:flutter_travel/pages/speak_page.dart';
import 'package:flutter_travel/util/navigator_util.dart';
import 'package:flutter_travel/widget/grid_nav.dart';
import 'package:flutter_travel/widget/loading_container.dart';
import 'package:flutter_travel/widget/local_nav.dart';
import 'package:flutter_travel/widget/sales_box.dart';
import 'package:flutter_travel/widget/search_bar.dart';
import 'package:flutter_travel/widget/sub_nav.dart';
import 'package:flutter_travel/widget/webview.dart';
//设置appbar的变化距离
const APPBAR_SCROLL_OFFSET = 100;
//设置搜索默认文字
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  static ConfigModel? configModel;

  //将此类定义为有状态的类
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //初始化appbar的透明度
  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel? gridNavModel;
  SalesBoxModel? salesBoxModel;
  bool _loading = true;

  //init生命周期
  @override
  void initState() {
    super.initState();
    //初始化页面信息
    _handleRefresh();
    // Future.delayed(Duration(milliseconds: 0), () {
    //   FlutterSplashScreen.hide();
    // });
  }

  //根据传递的距离来调整appbar的透明度
  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    //设置appbar的透明度
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }
  //异步获取数据
  Future<Null> _handleRefresh() async {
    try {
      //通过dao层获得数据
      HomeModel model = await HomeDao.fetch();
      setState(() {
        HomePage.configModel = model.config;
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        gridNavModel = model.gridNav;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }
  //构建页面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //设置背景色
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        //是否重新加载页面
          isLoading: _loading,
          //设置为堆栈小组件   可以覆盖
          child: Stack(
            children: <Widget>[
              //自带删除文本的搜索框
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                //下拉刷新
                child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    //通知监听器
                    child: NotificationListener(
                      //滑动监听
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification &&
                            scrollNotification.depth == 0) {
                          //滚动且是列表滚动的时候
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                        return false;
                      },
                      child: _listView,
                    )),
              ),
              _appBar
            ],
          )),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        //轮播图
        _banner,
        //加载推荐
        Padding(
          //内边距
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        //酒店，机票，旅游
        if (gridNavModel != null)
          Padding(
              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
              child: GridNav(gridNavModel: gridNavModel!)),
        //更多选项
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(subNavList: subNavList)),
        //热门活动
        if (salesBoxModel != null)
          Padding(
              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
              child: SalesBox(salesBox: salesBoxModel!)),
      ],
    );
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              //点击搜索框跳转
              inputBoxClick: _jumpToSearch,
              //语音识别
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
            height: appBarAlpha > 0.2 ? 0.5 : 0,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]))
      ],
    );
  }
//设置轮播图
  Widget get _banner {
    return Container(
      //高度为160
      height: 160,
      //swiper轮播图
      child: Swiper(
        //条目数为集合长度
        itemCount: bannerList.length,
        //自动播放
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(

            onTap: () {
              //点击获得集合的对应的信息
              CommonModel model = bannerList[index];
              //跳转到指定页面
              NavigatorUtil.push(
                  context,
                  HiWebView(
                      url: model.url,
                      title: model.title,
                      hideAppBar: model.hideAppBar));
            },
            //设置图片
            child: Image.network(
              bannerList[index].icon!,
              //填充满
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }
}
