import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todoitem.dart';
import 'package:todo_app/pages/todolist.dart';
import 'package:todo_app/providers/categorylist.dart';
import 'package:todo_app/providers/todolist.dart';
import 'package:todo_app/services/todo_service.dart';

class CategoryListBuilder extends StatelessWidget {
  CategoryListBuilder({Key? key, required this.list}) : super(key: key);

  List<Category> list;
  final TodoService _todoService = TodoService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _item(context, list[index], index);
        });
  }
}

Widget _item(context, Category list, int listIndex) {
  final CategoryListProvider categoryListProvider = CategoryListProvider();
  final TodoService todoService = TodoService();
  return Padding(
    padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
    child: Card(
        margin: const EdgeInsets.only(top: 3),
        child: ListTile(
          onTap: () {
            //todoListProvider.pickedCategory = list.title;
            Navigator.pushNamed(context, TodoList.routeName,
                arguments: list.title);
          },
          title: Text(
            list.title,
            style: TextStyle(
                fontSize: 23,
                fontStyle: FontStyle.italic,
                decorationThickness: 2.8,
                decorationColor: Colors.orange[500]),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              categoryListProvider.deleteCategory(list.title, listIndex);
              //await todoService.deleteCategory(list.title);
            },
          ),
        )),
  );
}
