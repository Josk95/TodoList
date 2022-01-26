import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/pages/todolist.dart';
import 'package:todo_app/providers/categorylist.dart';
import 'package:todo_app/services/todo_service.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Todo lists'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CategoryListProvider>(
        builder: (context, state, child) {
          return ListView.builder(
              itemCount: state.categoryList.length,
              itemBuilder: (context, index) {
                return _item(context, state.categoryList[index], index);
              });
        },
      ),
      floatingActionButton: _createCategory(context),
    );
  }

  Widget _listBuilder(context, List<Category> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _item(context, list[index], index);
        });
  }

  Widget _item(context, Category list, int listIndex) {
    var state = Provider.of<CategoryListProvider>(context, listen: false);
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
              onPressed: () async {
                await state.deleteCategory(list.title, listIndex);
                //await todoService.deleteCategory(list.title);
              },
            ),
          )),
    );
  }

  Widget _createCategory(context) {
    //final TodoService todoService = TodoService();
    var state = Provider.of<CategoryListProvider>(context, listen: false);
    String category = "";
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Center(child: Text("Add new Category")),
                  content: TextField(
                    onChanged: (value) => category = value,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          state.addCategory(category);
                          Navigator.pop(context);
                        },
                        child: Text("Add")),
                  ],
                ));
      },
      child: Icon(Icons.add),
    );
  }
}
