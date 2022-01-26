import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todoitem.dart';

class TodoService {
  final databaseRef = FirebaseFirestore.instance;

  //Implemented Try catch With failure only for this class for learning purpose
  Future<List<TodoItem>> fetchTodos() async {
    try {
      print('Fetch Ran');
      final Response response = await get(Uri.parse(
          'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=291dd6d6-a184-4613-b365-4d5ce24bd913'));
      return parseJson(response);
    } on SocketException {
      throw Failure(message: 'No Internet connection 😑');
    } on HttpException {
      throw Failure(message: "Couldn't find todos 😱");
    } on FormatException {
      throw Failure(message: "Bad response format 👎");
    }
  }

  Future<List<TodoItem>> postTodo(TodoItem item) async {
    try {
      Response response = await post(
          Uri.parse(
              'https://todoapp-api-pyq5q.ondigitalocean.app/todos?key=291dd6d6-a184-4613-b365-4d5ce24bd913'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(item));
      return parseJson(response);
    } catch (error) {
      //Return empty list if something goes wrong
      List<TodoItem> list = [];
      return list;
    }
  }

//Function to parse Json response to TodoItem
  List<TodoItem> parseJson(response) {
    List<dynamic> parsedList = jsonDecode(response.body);
    List<TodoItem> itemsList =
        List<TodoItem>.from(parsedList.map((i) => TodoItem.fromJson(i)));
    return itemsList;
  }

  Future<List<Category>> readTodosCategory() async {
    List<Category> todosList = [];
    Category item;

    await databaseRef.collection("todo_category").get().then((snapshot) => {
          snapshot.docs.forEach((doc) {
            item = Category(doc.id);
            todosList.add(item);
          })
        });

    return todosList;
  }

  Future<List<TodoItem>> getTodosFromCategory(String docId) async {
    List<TodoItem> itemsList = [];
    TodoItem item;

    await databaseRef
        .collection("todo_category")
        .doc(docId)
        .collection("Todos")
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((doc) {
                item = TodoItem(title: doc["title"], isDone: doc["isDone"]);
                itemsList.add(item);
              })
            });

    return itemsList;
  }

  Future<Category> addNewCategory(String categoryId) async {
    await databaseRef.collection("todo_category").doc(categoryId).set({});
    return Category(categoryId);
  }

  Future<TodoItem> addnewTodo(String categoryId, TodoItem item) async {
    await databaseRef
        .collection("todo_category")
        .doc(categoryId)
        .collection("Todos")
        .doc()
        .set({"title": item.title, "isDone": item.isDone});

    return TodoItem(title: item.title, isDone: item.isDone);
  }

  Future deleteCategory(String categoryId) async {
    print("Delete category was pressed");

    Future<QuerySnapshot> todos = databaseRef
        .collection("todo_category")
        .doc(categoryId)
        .collection("Todos")
        .get();
    todos.then((value) async {
      for (var element in value.docs) {
        await databaseRef
            .collection("todo_category")
            .doc(categoryId)
            .collection("Todos")
            .doc(element.id)
            .delete();
      }
    });
    //Delete Doc aswell
    await databaseRef.collection("todo_category").doc(categoryId).delete();
    return true;
  }
}

class Failure {
  final String message;

  Failure({this.message = ""});

  @override
  String toString() => message;
}
