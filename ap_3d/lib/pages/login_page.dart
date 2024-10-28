import 'package:ap_3d/pages/main_page.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Флаг для определения режима (вход/регистрация)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isLogin
                ? [
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                  ]
                : [
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  ],
            stops: const [0.1, 0.9], // Основной цвет занимает 90%
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/ZC.png', // Замените на правильный путь к файлу
                  //   height: 60, // Устанавливаем высоту изображения
                  // ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/ZC.png'), // Замените на путь к вашему аватару
                  ),
                  const SizedBox(width: 8),
                  // Добавляем текст "zerocoder"
                  Text(
                    'zerocoder',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Белый цвет текста
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Добавляем текст "Do"
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        //color: Colors.black.withOpacity(0.5), // Цвет тени (возникает ошибка!)
                        // color: Color(0x80000000), // Черный с прозрачностью 50% (работает!)
                        color: Color.fromRGBO(0, 0, 0, 0.5), // Черный с прозрачностью 50% (работает!)
                        offset: Offset(2, 2), // Смещение тени
                        blurRadius: 3, // Радиус размытия
                      ),
                    ],
                  ),
                  children: [
                    TextSpan(
                      text: 'Do',
                      style: TextStyle(
                        color: DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                    TextSpan(
                      text: 'Did',
                      style: TextStyle(
                        color: DoDidDoneTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'Done',
                      style: TextStyle(
                        color: DoDidDoneTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Заголовок
              Text(
                isLogin ? 'Вход' : 'Регистрация',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Поле логина/почты
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Почта',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Поле пароля
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // **Новое поле "Повторить пароль"**
              if (!isLogin) // Отображаем только при регистрации
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Повторить пароль',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              // Кнопка "Войти"
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isLogin
                      ? DoDidDoneTheme.lightTheme.colorScheme.primary
                      : DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
              ),
              const SizedBox(height: 20),
              // Кнопка перехода на другую страницу
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? 'У меня ещё нет аккаунта...' 
                      : 'Уже есть аккаунт...',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}