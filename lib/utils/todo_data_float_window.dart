import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todolist/src/rust/api/utils.dart';
import '../src/rust/api/types.dart';
import 'common.dart';

Future<TodoData?> showTodoDataFloatWindow(BuildContext context,
    [TodoData? initialData]) async {
  TextEditingController descriptionController =
      TextEditingController(text: initialData?.description);
  TextEditingController startTimeController =
      TextEditingController(text: initialData?.startTime);
  TextEditingController endTimeController =
      TextEditingController(text: initialData?.endTime);

  Completer<TodoData?> completer = Completer<TodoData?>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(initialData == null ? '添加 Todo' : '编辑 Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: '事件描述'),
            ),
            TextFormField(
              controller: startTimeController,
              decoration: const InputDecoration(labelText: '开始时间'),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                selectDateTime(context)
                    .then((value) => startTimeController.text = value);
              },
            ),
            TextFormField(
              controller: endTimeController,
              decoration: const InputDecoration(labelText: '结束时间'),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                selectDateTime(context)
                    .then((value) => endTimeController.text = value);
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(null);
            },
          ),
          TextButton(
            child: const Text('确定'),
            onPressed: () async {
              String id = initialData?.id ?? await genUuidV4();
              TodoData newTodo = TodoData(
                description: descriptionController.text,
                startTime: startTimeController.text,
                endTime: endTimeController.text,
                id: id,
              );
              if (!context.mounted) {
                completer.complete(newTodo);
                return;
              }
              Navigator.of(context).pop();
              completer.complete(newTodo);
            },
          ),
        ],
      );
    },
  );

  return completer.future;
}
