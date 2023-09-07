import 'package:flutter/material.dart';
import 'package:todoapp/controllers/task.controller.dart';
import 'package:todoapp/models/task.controller.dart';


class TaskListView extends StatefulWidget {
  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TaskController _taskController = TaskController();
  late Future<List<Task>> _tasksFuture;
  final TextEditingController _taskTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tasksFuture = _taskController.fetchTasks();
  }


  void _addTask() {
    final newTaskTitle = _taskTitleController.text;
    if (newTaskTitle.isNotEmpty) {
      final newTask = Task(
        id: DateTime.now().toString(),
        title: newTaskTitle,
        isCompleted: false,
      );
      _taskController.addTask(newTask);
      _taskTitleController.clear();
      setState(() {
        _tasksFuture = _taskController.fetchTasks();
      });
    }
  }

  void _toggleTaskCompletion(Task task) {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      isCompleted: !task.isCompleted,
    );
    _taskController.updateTask(updatedTask);
    setState(() {
      _tasksFuture = _taskController.fetchTasks();
    });
  }

  void _deleteTask(Task task) {
    _taskController.deleteTask(task);
    setState(() {
      _tasksFuture = _taskController.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final tasks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _toggleTaskCompletion(task),
                  ),
                  onLongPress: () => _deleteTask(task),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Task'),
                content: TextField(
                  controller: _taskTitleController,
                  decoration: InputDecoration(labelText: 'Task Title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addTask();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
