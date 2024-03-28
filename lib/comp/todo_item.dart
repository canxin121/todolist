import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../src/rust/api/types.dart';

class TodoItem extends StatelessWidget {
  final TodoData data;
  final Function(String) onDismissed;
  final Function(String) onEdit;

  const TodoItem({
    super.key,
    required this.data,
    required this.onDismissed,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(data.id), // 确保key是唯一的
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onEdit(data.id);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '编辑',
          ),
          SlidableAction(
            onPressed: (context) {
              onDismissed(data.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),
      child: Container(
        width: double.infinity, // 宽度填满屏幕
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 高度自适应内容
          crossAxisAlignment: CrossAxisAlignment.start, // 子部件居左对齐
          children: [
            Text(
              data.description,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              data.startTime.isNotEmpty && data.endTime.isNotEmpty
                  ? 'Start: ${data.startTime} End: ${data.endTime}'
                  : (data.startTime.isNotEmpty
                      ? 'Start: ${data.startTime}'
                      : (data.endTime.isNotEmpty
                          ? 'End: ${data.endTime}'
                          : '')),
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
