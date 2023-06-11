import 'package:flutter/material.dart';
import 'package:flutter_travel/widget/webview.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HiWebView(
        url: 'https://m.ctrip.com/webapp/myctrip/',
        //隐藏标题栏
        hideAppBar: true,
        //空安全适配，防止再生产环境导致的崩溃
        backForbid: true,
        statusBarColor: '4c5bca',
      ),
    );
  }
}
