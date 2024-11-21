import 'package:cloud_firestore/cloud_firestore.dart'; // Подключаем Firestore
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/task_item.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      stream: _tasksCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Ошибка при загрузке задач"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final tasks = snapshot.data!.docs;

        if (tasks.isEmpty) {
          return const Center(child: Text("Нет задач, время отдыхать ...\n или создать новую задачу?"));
        }


        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            final taskTitle = taskData['title'];
            final taskDescription = taskData['description'];
            final taskDeadline = (taskData['deadline'] as Timestamp).toDate();
            
            return TaskItem(
              title: taskTitle,
              description: taskDescription,
              deadline: taskDeadline,
              // Добавьте обработчики для изменения и удаления задач
              // onEdit: () {
              //   // Обработчик для изменения задачи
              //   // Например, можно открыть диалог для редактирования
              // },
              // onDelete: () {
              //   // Обработчик для удаления задачи
              //   // Например, можно показать диалог подтверждения
              //   _tasksCollection.doc(tasks[index].id).delete();
              // },
            );
          } 
        );
      }
    );
  }
}

