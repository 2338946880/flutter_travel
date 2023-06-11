import 'package:flutter/material.dart';

///自定义日期选择器
class DateRangPageState extends StatefulWidget {
  const DateRangPageState({Key? key}) : super(key: key);

  @override
  _DateRangPageStateState createState() => _DateRangPageStateState();
}

class _DateRangPageStateState extends State<DateRangPageState> {
  late String _dateSelectText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("日期范围选择"),
      ),
      body: Center(
        child: Text("当前选择 $_dateSelectText"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDateSelect();
        },
        child: Icon(Icons.select_all),
      ),
    );
  }

  void showDateSelect() async {
    //获取当前的时间
    DateTime start = DateTime.now();
    //在当前的时间上多添加4天
    DateTime end = DateTime(start.year, start.month, start.day + 4);

    //显示时间选择器
    DateTimeRange? selectTimeRange = await showDateRangePicker(
        //语言环境
        locale: Locale("zh", "CH"),
        context: context,
        //开始时间
        firstDate: DateTime(2020, 1),
        //结束时间
        lastDate: DateTime(2022, 1),
        cancelText: "取消",
        confirmText: "确定",
        //初始的时间范围选择
        initialDateRange: DateTimeRange(start: start, end: end));
    //结果
    _dateSelectText = selectTimeRange.toString();
    //选择结果中的开始时间
    DateTime? selectStart = selectTimeRange?.start;
    //选择结果中的结束时间
    DateTime? selectEnd = selectTimeRange?.end;

    setState(() {});
  }
}
