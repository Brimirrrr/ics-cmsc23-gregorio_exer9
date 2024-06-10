class Todo {
  String? id;
  int userId;
  bool completed;
  String title;

  Todo({
    this.id,
    required this.userId,
    required this.completed,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'completed': completed,
      'title': title,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String?,
      userId: json['userId'] as int? ?? 0, // provide default value if null
      completed: json['completed'] as bool? ?? false, // provide default value if null
      title: json['title'] as String? ?? '', // provide default value if null
    );
  }
}
