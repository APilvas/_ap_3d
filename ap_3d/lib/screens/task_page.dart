import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Добавьте пакет intl

import '../widgets/task_item.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // Пример списка задач. 
  // В реальном приложении этот список должен быть динамическим 
  // и управляться с помощью состояния приложения.
  final List<String> tasks = [
    'Купить продукты',
    'Записаться на тренировку',
    'Сделать зарядку',
    'Прочитать книгу',
    'Погулять в парке',
    'Выпить кофе',
    'Сделать яичницу',
    'Поработать над проетом',
    'Продолжить изучение языка Дарт',
    'Продумать структуру базы данных проекта',
    'Выполнить сканирование пленок',
  ];

  @override
  Widget build(BuildContext context) {
    return 
      ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return  TaskItem (
          title: tasks[index],
          description: 'Описание задачи',
          deadline: DateTime.now(),);
        },
      );
  }
}
