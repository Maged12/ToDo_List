import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../models/todo.dart';

class TodoItems extends StatefulWidget {
  final String message;
  final String id;
  final bool isChecked;
  TodoItems(
    this.message,
    this.id,
    this.isChecked,
  );
  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItems> {
  TextEditingController _controller;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final todo = Provider.of<Todos>(context, listen: false);
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Dismissible(
            key: ValueKey(widget.id),
            background: Container(
              color: Theme.of(context).errorColor,
              child: Icon(
                Icons.delete_sweep,
                color: Colors.white,
                size: 40,
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(
                right: 20,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              todo.remTodo(widget.id);
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                      size: 40,
                      color:
                          widget.isChecked ? Colors.green : Colors.transparent,
                    ),
                  ),
                  title: Text(
                    widget.message,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 25,
                          color: Colors.amberAccent,
                        ),
                        onPressed: () {

                          _controller =
                              TextEditingController(text: widget.message);
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Padding(
                                padding: MediaQuery.of(ctx).viewInsets,
                                child: Container(
                                  color: Color(0xFF737373),
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          TextField(
                                            controller: _controller,
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              labelText: 'ToDo Messages',
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(5),
                                            child: RaisedButton(
                                              color: Colors.blue,
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  _loading = true;
                                                });
                                                await todo.editTodo(
                                                  widget.id,
                                                  TodoItem(
                                                    id: widget.id,
                                                    message: _controller.text,
                                                    isChecked: widget.isChecked,
                                                  ),
                                                );
                                                setState(() {
                                                  _loading = false;
                                                });
                                              },
                                              child: Text(
                                                'Edit',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    todo.toggleCheckStatus(
                      TodoItem(
                        message: widget.message,
                        id: widget.id,
                        isChecked: widget.isChecked,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
