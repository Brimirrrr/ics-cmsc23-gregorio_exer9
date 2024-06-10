import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_list_provider.dart';
import '../models/todo.dart';
import 'todo_modal.dart';
import 'login.dart';
import '../providers/auth_provider.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Add this import

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<MyAuthProvider>().userStream;
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;

    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, userSnapshot) {
        if (userSnapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${userSnapshot.error}"),
          );
        } else if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!userSnapshot.hasData) {
          return LoginPage();
        }

        // if user is logged in, display the scaffold containing the streambuilder for the todos
        return Scaffold(
          appBar: AppBar(
            title: Text('Todo List'),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: todosStream,
            builder: (context, todosSnapshot) {
              if (todosSnapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${todosSnapshot.error}"),
                );
              } else if (todosSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!todosSnapshot.hasData || todosSnapshot.data?.docs.isEmpty == true) {
                return Center(
                  child: Text("No Todos Found"),
                );
              }

              return ListView.builder(
                itemCount: todosSnapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  final doc = todosSnapshot.data?.docs[index];
                  if (doc == null) return SizedBox.shrink(); // Handle null document

                  Todo todo = Todo.fromJson(doc.data() as Map<String, dynamic>);
                  todo.id = doc.id;
                  return Dismissible(
                    key: Key(todo.id.toString()),
                    onDismissed: (direction) {
                      context.read<TodoListProvider>().deleteTodo(todo.id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${todo.title} dismissed')));
                    },
                    background: Container(color: Colors.red, child: const Icon(Icons.delete)),
                    child: ListTile(
                      title: Text(todo.title),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) {
                          if (value != null) {
                            context.read<TodoListProvider>().toggleStatus(todo.id!, value);
                          }
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => TodoModal(type: 'Edit', item: todo),
                              );
                            },
                            icon: const Icon(Icons.create_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => TodoModal(type: 'Delete', item: todo),
                              );
                            },
                            icon: const Icon(Icons.delete_outlined),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => TodoModal(type: 'Add'),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
