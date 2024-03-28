// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todolist/src/rust/api/config.dart';
import 'package:todolist/src/rust/api/types.dart';
import 'package:todolist/src/rust/frb_generated.dart';
import 'comp/todo_item.dart';
import 'utils/todo_data_float_window.dart';
import 'package:path_provider/path_provider.dart';

import 'utils/common.dart';

List<TodoData> globalTodoList = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  await setupLogger();
  Directory cacheDirectory = await getApplicationCacheDirectory();
  await initConfig(config: Config(cacheRoot: cacheDirectory.absolute.path));

  // 在这里调用getTodolist()来初始化globalTodoList
  globalTodoList = await getTodolist();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ...globalTodoList.map((data) => TodoItem(
                data: data,
                onDismissed: (id) {
                  setState(() {
                    globalTodoList.removeWhere((item) => item.id == id);
                    writeTodolist(todolist: globalTodoList);
                  });
                },
                onEdit: (id) {
                  final index =
                      globalTodoList.indexWhere((item) => item.id == id);
                  showTodoDataFloatWindow(context, globalTodoList[index])
                      .then((value) => setState(() {
                            if (value != null && value.description.isNotEmpty) {
                              globalTodoList[index] = value;
                              writeTodolist(todolist: globalTodoList);
                            }
                          }));
                },
              ))
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showTodoDataFloatWindow(context).then((value) => setState(() {
                if (value != null && value.description.isNotEmpty) {
                  globalTodoList.add(value);
                  writeTodolist(todolist: globalTodoList);
                }
              }))
        },
        tooltip: '添加 Todo',
        child: const Icon(Icons.add),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Container(height: 50.0),
      // ),
    );
  }
}
