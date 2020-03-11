import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';

class AddItem extends StatelessWidget {
  final Function addTodo;
  String message = '';
  AddItem({
    @required this.addTodo,
    this.message,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            message = value;
                          },
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
                              addTodo(true);
                              await Provider.of<Todos>(context, listen: false)
                                  .addTodo(message);
                              addTodo(false);
                            },
                            child: Text(
                              'Add',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
