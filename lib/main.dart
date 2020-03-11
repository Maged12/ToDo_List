import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/todo_screen.dart';
import './models/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Todos(),
      child: MaterialApp(
        title: "ToDo",
        home: TodoScreen(),
      ),
    );
  }
}
