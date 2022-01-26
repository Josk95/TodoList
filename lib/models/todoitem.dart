import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  final String title;
  bool isDone;

  TodoItem({required this.title, required this.isDone});

  factory TodoItem.fromJson(Map<dynamic, dynamic> json) => TodoItem(
        // id: json['id'],
        title: json['title'],
        isDone: json['done'],
      );

  //Map<String, dynamic> toJson() => {"id": id, "title": title, "done": done};

  String toString() {
    return "{title: $title, isDone: $isDone}";
  }
}
