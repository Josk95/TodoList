import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todolist.dart';

class Filter extends StatelessWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<TodoListProvider>(context, listen: false);
    return PopupMenuButton(
        onSelected: (int value) {
          state.setFilterby(value);
        },
        itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Visa alla'), value: 1),
              const PopupMenuItem(child: Text('Gjorda'), value: 2),
              const PopupMenuItem(child: Text('Att göra'), value: 3)
            ]);
  }
}
