import 'package:flutter/material.dart';

import 'navigator/tab_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //不显示 debug标签
      debugShowCheckedModeBanner: false,
      // //当前运行环境配置
      // locale: Locale("zh", "CH"),
      // //程序支持的语言环境配置
      // supportedLocales: [Locale("zh", "CH")],
      // //Material 风格代理配置
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      title: 'Flutter行程助手',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
    //上传
  }
}
