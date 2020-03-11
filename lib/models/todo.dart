import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoItem {
  final String id;
  final String message;
  bool isChecked;
  TodoItem({
    @required this.message,
    @required this.id,
    this.isChecked = false,
  });
}

class Todos with ChangeNotifier {
  List<TodoItem> _todos = [];
  List<TodoItem> get todos {
    return _todos;
  }

  Future<void> fetchTodos() async {
    const url = 'https://todolist-4caab.firebaseio.com/todos.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      final List<TodoItem> loadedTodos = [];
      extractedData.forEach((todoId, todoData) {
        loadedTodos.add(TodoItem(
          id: todoId,
          message: todoData['message'],
          isChecked: todoData['isChecked'],
        ));
      });
      _todos = loadedTodos;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addTodo(String mes) async {
    const url = 'https://todolist-4caab.firebaseio.com/todos.json';
    final response = await http.post(
      url,
      body: json.encode({
        'message': mes,
        'isChecked': false,
      }),
    );
    _todos.add(TodoItem(
      id: json.decode(response.body)['name'],
      message: mes,
    ));
    notifyListeners();
  }

  int findToDoIndex(String id) {
    return _todos.indexWhere((todo) => todo.id == id);
  }

  Future<void> remTodo(String id) async {
    final url = 'https://todolist-4caab.firebaseio.com/todos/$id.json';
    final exTodoIndex = findToDoIndex(id);
    var exTodo = _todos[exTodoIndex];
    _todos.removeAt(exTodoIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _todos.insert(exTodoIndex, exTodo);
      notifyListeners();
    }
  }

  Future<void> editTodo(String id, TodoItem todo) async {
    final int index = findToDoIndex(id);
    final url = 'https://todolist-4caab.firebaseio.com/todos/$id.json';
    await http.patch(
      url,
      body: json.encode({
        'message': todo.message,
        'isChecked': todo.isChecked,
      }),
    );
    _todos[index] = todo;
    notifyListeners();
  }

  Future<void> toggleCheckStatus(TodoItem todo) async {
    final int index = findToDoIndex(todo.id);
    final url = 'https://todolist-4caab.firebaseio.com/todos/${todo.id}.json';
    final oldState = todo.isChecked;
    todo.isChecked = !todo.isChecked;
    _todos[index] = todo;
    notifyListeners();
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'message': todo.message,
          'isChecked': todo.isChecked,
        }),
      );
      if (response.statusCode >= 400) {
        print('lol');
        todo.isChecked = oldState;
        _todos[index] = todo;
        notifyListeners();
      }
    } catch (error) {
      print('lol2');
      todo.isChecked = oldState;
      _todos[index] = todo;
      notifyListeners();
    }
  }
}
