import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todoitem.dart';
import 'package:todo_app/providers/todolist.dart';

class TodoListBuilder extends StatelessWidget {
  TodoListBuilder({Key? key, required this.list}) : super(key: key);

  List<TodoItem> list;

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<TodoListProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      child: RefreshIndicator(
        onRefresh: () async {
          state.fetchTodo();
        },
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return _item(context, list[index]);
            }),
      ),
    );
  }
}

Widget _item(context, TodoItem item) {
  //Get State from provider
  var state = Provider.of<TodoListProvider>(context, listen: false);
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
                decoration: item.done ? TextDecoration.lineThrough : null,
                decorationThickness: 2.8,
                decorationColor: Colors.orange[500]),
          ),
          secondary: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey[900],
              ),
              onPressed: () {
                state.deleteItem(item);
              }),
          controlAffinity: ListTileControlAffinity.leading,
          value: item.done,
          onChanged: (value) {
            item.done = !item.done; //Change value of checkbox to opposite value
            state.isCompleted(item);
          },
        )),
  );
}
