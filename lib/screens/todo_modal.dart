import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_list_provider.dart';

class TodoModal extends StatefulWidget {
  final String type;
  final Todo? item;

  TodoModal({required this.type, this.item});

  @override
  _TodoModalState createState() => _TodoModalState();
}

class _TodoModalState extends State<TodoModal> {
  final TextEditingController _formFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _formFieldController.text = widget.item!.title;
    }
  }

  void _dialogAction() {
    switch (widget.type) {
      case 'Add':
        {
          Todo temp = Todo(
            userId: 1,
            completed: false,
            title: _formFieldController.text,
          );
          context.read<TodoListProvider>().addTodo(temp);
          Navigator.of(context).pop();
          break;
        }
      case 'Delete':
        {
          context.read<TodoListProvider>().deleteTodo(widget.item!.id!);
          Navigator.of(context).pop();
          break;
        }
      case 'Edit':
        {
          // Implement edit functionality here
          Navigator.of(context).pop();
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.type} Todo'),
      content: widget.type == 'Delete'
          ? Text("Are you sure you want to delete ${widget.item!.title}?")
          : TextField(
              controller: _formFieldController,
              decoration: InputDecoration(hintText: 'Enter todo title'),
            ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _dialogAction,
          child: Text('OK'),
        ),
      ],
    );
  }
}
