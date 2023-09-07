import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/task.controller.dart';

class TaskController {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> fetchTasks() async {
    QuerySnapshot snapshot = await _firestore.collection('tasks').get();
    List<Task> tasks = [];

    snapshot.docs.forEach((doc) {
      tasks.add(Task(
        id: doc.id,
        title: doc['title'],
        isCompleted: doc['isCompleted'],
      ));
    });

    return tasks;
  }

  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add({
      'title': task.title,
      'isCompleted': task.isCompleted,
    });
  }

  

  // Agrega métodos para actualizar y eliminar tareas aquí.
  
  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
      'isCompleted': task.isCompleted,
    });
  }

  Future<void> deleteTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).delete();
  }
}
