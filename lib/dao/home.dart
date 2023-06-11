import 'dart:async';
import 'dart:convert';

import 'package:flutter_travel/model/home_model.dart';
import 'package:http/http.dart' as http;

//首页网址
const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';

///首页大接口
class HomeDao {
  //async-await 通过同步代码结构来实现异步操作
  static Future<HomeModel> fetch() async {
    var url = Uri.parse(HOME_URL);
    //使用await关键字必须配合async关键字一起使用才会起作用
    final response = await http.get(url);
    //判断返回值
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
      //对变量进行 JSON 编码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      //把结果返回
      return HomeModel.fromJson(result);
    } else {
      //抛出异常
      throw Exception('Failed to load home_page.json');
    }
  }
}
