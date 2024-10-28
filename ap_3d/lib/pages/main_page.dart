// Страница Main - главная страница приложения. Версия 23.09.2024
// Показывает пустую страницу. Внизу - иконки  
// Вызывает Taskpage и ProfilePage


import 'package:ap_3d/screens/profile_page.dart';
import 'package:ap_3d/screens/task_page.dart'; 
import 'package:flutter/material.dart';
import 'package:ap_3d/theme/theme.dart';
import 'package:intl/intl.dart'; // Импортируем пакет intl для форматирования даты


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Для хранения выбранной даты и времени
  DateTime? _selectedDate;

  static final List<Widget> _widgetOptions = <Widget>[
    const TaskPage(),
    const Center(child: Text('Сегодня')),
    const Center(child: Text('Выполнено')),
    const ProfilePage(), // Now shows ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для отображения диалогового окна добавления задачи
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Используем StatefulBuilder для обновления состояния диалога
          builder: (context, setState) { // Передаем setState в билдер
            return AlertDialog(
              title: const Text('Добавить задачу'),
              content: SingleChildScrollView( // Оборачиваем в SingleChildScrollView для предотвращения ошибок переполнения
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      decoration: InputDecoration(hintText: 'Название задачи'),
                    ),
                    const SizedBox(height: 16.0),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Описание'),
                    ),
                    const SizedBox(height: 16.0),
                    // Кнопка выбора даты и времени
                    ElevatedButton(
                      onPressed: () async {
                        // Выбираем дату и время
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _selectedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text( 
                        _selectedDate != null
                            ? 'Дедлайн: ${DateFormat('dd.MM.yyyy HH:mm').format(_selectedDate!)}'
                            : 'Выбрать дедлайн',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрыть диалог
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Добавить логику сохранения задачи
                    Navigator.of(context).pop(); // Закрыть диалог
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DoDidDoneTheme.lightTheme.colorScheme.secondary,
              DoDidDoneTheme.lightTheme.colorScheme.primary,
            ],
            stops: const [0.2, 0.8],
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
