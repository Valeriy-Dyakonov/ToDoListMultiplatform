class Task {
  int? id;
  String name;
  String category;
  String date;
  String content;
  String done;
  bool selected;

  Task({
    this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.content,
    required this.done,
    required this.selected,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        date: json["date"],
        content: json["content"],
        done: json["done"],
        selected: false,
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "category": category,
        "date": date,
        "content": content,
        "done": done,
      };
}
