import 'package:flutter/material.dart';
import 'package:ncmb/ncmb.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import './schedule_form.dart';
import './schedule_list.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<NCMBObject> _schedules = [];
  List<NCMBObject> _selectedSchedules = [];
  var _focusDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getSchedule();
  }

  void _getSchedule() async {
    // 予定検索用クエリー
    var query = NCMBQuery("Schedule");
    // 基準日時
    var date = DateTime.now();
    // 月初
    DateTime startDate = DateTime(date.year, date.month, 1);
    // 翌月初
    DateTime endDate =
        DateTime(date.year, date.month + 1, 1).add(const Duration(days: -1));
    // 検索条件を設定
    query
      ..greaterThanOrEqualTo("startDate", startDate)
      ..lessThan("endDate", endDate);
    // 検索実行
    var schedules =
        (await query.fetchAll()).map((s) => s as NCMBObject).toList();
    // 表示に反映
    setState(() {
      _schedules = schedules;
    });
  }

  // イベントの有無を返す関数
  List<NCMBObject> _eventLoader(DateTime day) {
    // 日付毎に呼ばれる
    return _filterdSchedule(day, updateSelected: false);
  }

  // ある日付に存在するスケジュールを一覧で返す関数
  List<NCMBObject> _filterdSchedule(DateTime day, {updateSelected = true}) {
    // 日付を文字列にするフォーマッタ
    final dateFormat = DateFormat('yyyy/MM/dd');
    final targetDate = dateFormat.format(day);
    // フィルタリング
    final schedules = _schedules
        .where((schedule) =>
            dateFormat.format(schedule.getDateTime("startDate",
                defaultValue: DateTime.now())) ==
            targetDate)
        .toList();
    // 一覧表示の場合はtrue
    if (updateSelected) {
      setState(() {
        _selectedSchedules = schedules;
      });
    }
    return schedules;
  }

  void _addSchedule() async {
    var schedule = await Navigator.push(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: '/new'),
            builder: (BuildContext context) =>
                ScheduleFormPage(schedule: NCMBObject("Schedule"))));
    if (schedule != null) {
      _schedules.add(schedule as NCMBObject);
    }
  }

  // 日付を選択した際の処理
  void _onDaySelected(selectedDay, focusedDay) {
    // フォーカス日を更新
    setState(() {
      _focusDate = selectedDay;
    });
    // フィルタリングを実行
    _filterdSchedule(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("カレンダー"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addSchedule,
            )
          ],
        ),
        body: Column(children: [
          TableCalendar(
            locale: 'ja',
            eventLoader: _eventLoader,
            firstDay: DateTime.utc(2010, 10, 16, 10),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusDate,
            onDaySelected: _onDaySelected,
          ),
          _selectedSchedules.isEmpty
              ? const Text("該当日にイベントはありません")
              : Expanded(
                  child: ListView.builder(
                      itemCount: _selectedSchedules.length,
                      itemBuilder: (BuildContext context, int index) {
                        final schedule = _selectedSchedules[index];
                        return ScheduleListPage(
                          schedule: schedule,
                          onEdited: (NCMBObject schedule) {
                            setState(() {
                              _selectedSchedules[index] = schedule;
                            });
                          },
                        );
                      }))
        ]));
  }
}
