import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todoitem.dart';
import 'package:todo_app/services/todo_service.dart';

class TodoListProvider with ChangeNotifier {
  //Instance of TodoService class
  final _todoService = TodoService();

  //Setter for todoList. Takes an list an add to TodoList.

  List<TodoItem> todoList = [];
  List<TodoItem> get list => todoList;

  String pickedCategory = "";

  void _setList(List<TodoItem> list) {
    todoList = list;
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

  void addTodo(String categoryId, TodoItem item) async {
    await _todoService.addnewTodo(categoryId, item);
    todoList.add(item);
    print(todoList.toString());
    notifyListeners();
  }

  Future getTodosFromCategory(String docId) async {
    todoList = await _todoService.getTodosFromCategory(docId);
    notifyListeners();
    return todoList;
  }

/*

  

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
  */
/*
  Future<void> getTodosList() async {
    try {
      QuerySnapshot snapshot = await _todoService.readTodosCategory();

      print(snapshot.docs[0].data());

      for (var i = 0; i < snapshot.docs.length; i++) {
        item = TodoItem(
            title: snapshot.docs[i].get("title"),
            isDone: snapshot.docs[i].get("isDone"));
        resultList.add(item);
      }
      _setList(resultList);
      print(resultList.toString());
    } catch (e) {}
  }
  */

  //Set filterBy
  void setFilterby(int filterBy) {
    _filterBy = filterBy;
    notifyListeners();
  }

  //Function to filter list
  List<TodoItem>? filterList(list, value) {
    if (value == 2) {
      return todoList.where((item) => item.isDone == true).toList();
    } else if (value == 3) {
      return todoList.where((item) => item.isDone == false).toList();
    }
    return todoList;
  }

  //Add ItemObjekt to list
  void addItem(TodoItem item) async {
    var result = await _todoService.postTodo(item);
    _setList(result);
  }
/*
  //Delete ItemObjekt from list
  void deleteItem(TodoItem item) async {
    _setList(await _todoService.deleteTodoItem(item));
  }

  //Change ItemObjekt to opposite value of current value
  void isCompleted(TodoItem item) async {
    _setList(await _todoService.updateTodo(item));
  }
  */

}
