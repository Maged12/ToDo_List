import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_item.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool _loading = false;

  Future<void> _refreshTodos(BuildContext context) async {
    try {
      await Provider.of<Todos>(context, listen: false).fetchTodos();
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong try again later!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  void addTodo(bool load) {
    setState(() {
      _loading = load;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('ToDO Task'),
        actions: <Widget>[
          AddItem(addTodo: addTodo),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: _refreshTodos(context),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refreshTodos(context),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Consumer<Todos>(
                              builder: (ctx, todoData, _) => ListView.builder(
                                itemBuilder: (ctx, i) => TodoItems(
                                  todoData.todos[i].message,
                                  todoData.todos[i].id,
                                  todoData.todos[i].isChecked,
                                ),
                                itemCount: todoData.todos.length,
                              ),
                            ),
                          ),
                        ),
            ),
    );
  }
}
