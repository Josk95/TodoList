import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/add_todo.dart';
import 'package:todo_app/pages/todolist.dart';
import 'package:todo_app/providers/categorylist.dart';
import 'package:todo_app/providers/todolist.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/todo_service.dart';

//Main function to run App. Created for future routing
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoListProvider>(
            create: (context) => TodoListProvider()),
        ChangeNotifierProvider<CategoryListProvider>(
            create: (context) => CategoryListProvider()),
      ],
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        //home: Home(),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/add': (context) => const AddTodo(),
          TodoList.routeName: (context) => TodoList(),
        },
        theme: ThemeData(primarySwatch: Colors.orange),
      ),
    );
  }
}
