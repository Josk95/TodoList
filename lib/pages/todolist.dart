import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/models/todoitem.dart';
import 'package:todo_app/providers/todolist.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/shared/filter_todo.dart';
import 'package:todo_app/todolist_builder.dart';

class TodoList extends StatefulWidget {
  TodoList({Key? key}) : super(key: key) {}
  static const routeName = '/todos';
  final TodoListProvider todoListProvider = TodoListProvider();
  final TodoService todoService = TodoService();

  List<TodoItem> todoItem = [];
  @override
  State<TodoList> createState() => _TodoListState();

  Future<void> getTodos(String categoryId) async {
    todoItem = await todoListProvider.getTodosFromCategory(categoryId);
  }
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    String categoryId = ModalRoute.of(context)!.settings.arguments as String;
    var state = Provider.of<TodoListProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryId),
        centerTitle: true,
        actions: [
          Filter(),
        ],
      ),
      body: FutureBuilder(
        future: widget.getTodos(categoryId),
        builder: (BuildContext context, todoItem) {
          return ListView.builder(
              itemCount: widget.todoItem.length,
              itemBuilder: (context, index) {
                return _item(context, widget.todoItem[index]);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic item = await Navigator.pushNamed(context, '/add');
          if (item != null) {
            var state = Provider.of<TodoListProvider>(context, listen: false);
            widget.todoService.addnewTodo(categoryId, item);
            setState(() {
              widget.todoItem.add(item);
            });
          }
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}

Widget _item(context, TodoItem item) {
  return Padding(
    padding: const EdgeInsets.only(top: 2, left: 5, right: 5),
    child: Card(
        margin: const EdgeInsets.only(top: 3),
        child: CheckboxListTile(
          title: Text(
            item.title,
            style: TextStyle(
                fontSize: 23,
                fontStyle: FontStyle.italic,
                decoration: item.isDone ? TextDecoration.lineThrough : null,
                decorationThickness: 2.8,
                decorationColor: Colors.orange[500]),
          ),
          secondary: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey[900],
              ),
              onPressed: () {
                //state.deleteItem(item);
              }),
          controlAffinity: ListTileControlAffinity.leading,
          value: item.isDone,
          onChanged: (value) {
            item.isDone =
                !item.isDone; //Change value of checkbox to opposite value
            // state.isCompleted(item);
          },
        )),
  );
}

Widget _floatingActionButton(String categoryId, context) {
  final TodoService todoService = TodoService();
  return FloatingActionButton(
    onPressed: () async {
      dynamic item = await Navigator.pushNamed(context, '/add');
      if (item != null) {
        var state = Provider.of<TodoListProvider>(context, listen: false);
        todoService.addnewTodo(categoryId, item);
      }
    },
    child: const Icon(
      Icons.add,
      size: 40,
    ),
  );
}
