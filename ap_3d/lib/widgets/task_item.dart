// Виджет StatelessWidget (виджет без состояния), отображающий карточку задачи. Версия 23.09.2024 16:03
// Формат даты Дедлайна отформатирован: 'dd.MM.yy HH:mm'
// Карточка задач отображает задачу, подсвеченную градиентом:
// Красным (дедлайн - 1 день), желтым (2 дня), зеленым (более 2 дней)
// Градиент растянут на всю карточку

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Импортируем пакет intl

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime deadline;

  const TaskItem({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Форматируем дату и время
    String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);

    // Определяем градиент в зависимости от срочности
    // LinearGradient gradient;
    Duration timeUntilDeadline = deadline.difference(DateTime.now());
    Color gradientStart;
    if (timeUntilDeadline.inDays < 1) {
      gradientStart = Colors.red.withOpacity(0.5); // Срочная
    } else if (timeUntilDeadline.inDays < 2) {
      gradientStart = Colors.yellow.withOpacity(0.5); // Средняя срочность
    } else {
      gradientStart = Colors.green.withOpacity(0.5); // Не срочная
    }

    return Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок с градиентом
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [gradientStart, Colors.white],
                      //stops: const [0.1, 0.9],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),

                  // Растягиваем градиент на всю ширину карточки задачи
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    
                      // Иконки редактирования и удаления задачи в верхней части карточки (размещены на градиенте)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Действие при нажатии на кнопку "Редактировать"
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Действие при нажатии на кнопку "Удалить"
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Описание задачи
                    Text(description),
                    const SizedBox(height: 4.0),
                    // Дедлайн
                    Text(
                      'Дедлайн: $formattedDeadline', // Используем отформатированную дату
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],),
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

// Перечисление для определения срочности задачи
//enum TaskUrgency {
//  urgent,
//  medium,
//  notUrgent,
//}
