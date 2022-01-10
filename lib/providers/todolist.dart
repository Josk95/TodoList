import 'package:flutter/material.dart';
import 'package:todo_app/models/todoitem.dart';
import 'package:todo_app/services/todo_service.dart';

enum NotifierState { initial, loading, loaded }

class TodoListProvider with ChangeNotifier {
  TodoListProvider() {
    fetchTodo();
  }

  //Instance of TodoService class
  final _todoService = TodoService();

  NotifierState _state = NotifierState.initial;
  NotifierState get providerState => _state;
  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  //Setter for todoList. Takes an list an add to TodoList.
  List<TodoItem> _todoList = [];
  List<TodoItem> get list => _todoList;
  void _setList(List<TodoItem> list) {
    _todoList = list;
    notifyListeners();
  }

  //Setter for error handler
  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure f) {
    _failure = f;
    notifyListeners();
  }

  int _filterBy = 3;
  //Get filter Value
  int get filterBy => _filterBy;

  //Fetch todo List
  void fetchTodo() async {
    _setState(NotifierState.loading);
    try {
      var result = await _todoService.fetchTodos();
      _failure = null;
      _setList(result);
    } on Failure catch (f) {
      _setFailure(f);
    }
    _setState(NotifierState.loaded);
  }

  //Set filterBy
  void setFilterby(int filterBy) {
    _filterBy = filterBy;
    notifyListeners();
  }

  //Function to filter list
  List<TodoItem> filterList(list, value) {
    if (value == 2) {
      return _todoList.where((item) => item.done == true).toList();
    } else if (value == 3) {
      return _todoList.where((item) => item.done == false).toList();
    }
    return _todoList;
  }

  //Add ItemObjekt to list
  void addItem(TodoItem item) async {
    var result = await _todoService.postTodo(item);
    _setList(result);
  }

  //Delete ItemObjekt from list
  void deleteItem(TodoItem item) async {
    _setList(await _todoService.deleteTodoItem(item));
  }

  //Change ItemObjekt to opposite value of current value
  void isCompleted(TodoItem item) async {
    _setList(await _todoService.updateTodo(item));
  }
}
