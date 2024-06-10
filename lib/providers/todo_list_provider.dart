import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_todo_api.dart';
import '../models/todo.dart';

class TodoListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;

  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchTodos();
  }

  Stream<QuerySnapshot> get todos => _todosStream;

  fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson());
    print(message);
    notifyListeners();
  }

  void deleteTodo(String id) async {
    String message = await firebaseService.deleteTodo(id);
    print(message);
    notifyListeners();
  }

  void toggleStatus(String id, bool newStatus) async {
    String message = await firebaseService.updateTodoStatus(id, newStatus);
    print(message);
    notifyListeners();
  }
}
