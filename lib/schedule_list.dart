import 'package:flutter/material.dart';
import 'package:ncmb/ncmb.dart';
import 'package:intl/intl.dart';
import './schedule_form.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage(
      {super.key, required this.schedule, required this.onEdited});

  final NCMBObject schedule;
  final Function onEdited;

  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  final dateFormat = DateFormat('HH:MM');

  String _viewTime() {
    final startString =
        dateFormat.format(widget.schedule.getDateTime("startDate"));
    final endString = dateFormat.format(widget.schedule.getDateTime("endDate"));
    return "$startString〜$endString";
  }

  void _onTap() async {
    var schedule = await Navigator.push(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: '/new'),
            builder: (BuildContext context) =>
                ScheduleFormPage(schedule: widget.schedule)));
    if (schedule != null) {
      widget.onEdited(schedule);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTap,
        child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black38),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(widget.schedule
                        .getString("title", defaultValue: "タイトルなし")),
                    const Spacer(),
                    Text(_viewTime())
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        widget.schedule.getString("body", defaultValue: "")))
              ],
            )));
  }
}
