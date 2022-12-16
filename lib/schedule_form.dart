import 'package:flutter/material.dart';
import 'package:ncmb/ncmb.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class ScheduleFormPage extends StatefulWidget {
  const ScheduleFormPage({super.key, required this.schedule});

  final NCMBObject schedule;

  @override
  State<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends State<ScheduleFormPage> {
  var _title = "";
  var _body = "";
  final _startDateController = TextEditingController();
  var _startDate = DateTime.now();
  final _endDateController = TextEditingController();
  var _endDate = DateTime.now();
  final _dateFormat = DateFormat('yyyy/MM/dd HH:mm');

  @override
  void initState() {
    setState(() {
      _title = widget.schedule.getString("title", defaultValue: "");
      _body = widget.schedule.getString("body", defaultValue: "");
      if (widget.schedule.objectId == null) {
        _endDate = _startDate.add(const Duration(hours: 1));
      } else {
        _startDate = widget.schedule
            .getDateTime("startDate", defaultValue: DateTime.now());
        _endDate = widget.schedule
            .getDateTime("endDate", defaultValue: DateTime.now());
      }
      _startDateController.text = _dateFormat.format(_startDate);
      _endDateController.text = _dateFormat.format(_endDate);
    });
    super.initState();
  }

  void _showDateTimePicker(String field) {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        if (field == "startDate") {
          _startDate = date;
          _startDateController.text = _dateFormat.format(_startDate);
          _endDate = _startDate.add(const Duration(hours: 1));
        } else {
          _endDate = date;
        }
        _endDateController.text = _dateFormat.format(_endDate);
      });
    },
        currentTime: field == "startDate" ? _startDate : _endDate,
        locale: LocaleType.jp);
  }

  void _save() async {
    // 入力データを適用
    widget.schedule
      ..set("title", _title)
      ..set("body", _body)
      ..set("startDate", _startDate)
      ..set("endDate", _endDate);
    // ACL（アクセス権限）を設定
    var acl = NCMBAcl();
    var user = await NCMBUser.currentUser();
    acl
      ..setUserReadAccess(user!, true)
      ..setUserWriteAccess(user, true);
    widget.schedule.set("acl", acl);
    // 保存実行
    await widget.schedule.save();
    // 前の画面に戻る
    Navigator.pop(context, widget.schedule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("予定の追加・編集"),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                height: 50,
                width: 250,
                child: TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration.collapsed(hintText: 'タイトル'),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                )),
            SizedBox(
                height: 50,
                width: 250,
                child: TextFormField(
                  initialValue: _body,
                  decoration: const InputDecoration.collapsed(hintText: '予定詳細'),
                  maxLines: 10,
                  onChanged: (value) {
                    setState(() {
                      _body = value;
                    });
                  },
                )),
            SizedBox(
                height: 50,
                width: 250,
                child: TextFormField(
                    controller: _startDateController,
                    decoration:
                        const InputDecoration.collapsed(hintText: '開始日時'),
                    maxLines: 10,
                    enableInteractiveSelection: false,
                    onTap: () => _showDateTimePicker("startDate"))),
            SizedBox(
                height: 50,
                width: 250,
                child: TextFormField(
                    controller: _endDateController,
                    decoration:
                        const InputDecoration.collapsed(hintText: '終了日時'),
                    maxLines: 10,
                    enableInteractiveSelection: false,
                    onTap: () => _showDateTimePicker("endDate"))),
            TextButton(onPressed: _save, child: const Text("保存する")),
          ])
        ]));
  }
}
