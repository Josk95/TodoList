class TodoItem {
  final String id;
  final String title;
  bool done;

  TodoItem({this.id = "", required this.title, required this.done});

  factory TodoItem.fromJson(Map<dynamic, dynamic> json) => TodoItem(
        id: json['id'],
        title: json['title'],
        done: json['done'],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "done": done
  };

  @override
  String toString() {
    return "{id: $id title: $title}";
  }
}
