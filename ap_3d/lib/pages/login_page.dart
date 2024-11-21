import 'package:ap_3d/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ap_3d/services/firebase_auth.dart'; // Импортируем AuthenticationService
import '../theme/theme.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _emailController = TextEditingController(); // Контроллер для поля email
  final _passwordController = TextEditingController(); // Контроллер для поля пароля
  final _confirmpasswordController = TextEditingController(); // Контроллер для поля подтверждения пароля
  final _authenticationService = AuthenticationService(); // Сервис аутентификации
  
  bool isLogin = true; // Флаг для определения режима (вход/регистрация)
  bool isLoading = false; // Флаг для индикатора загрузки
  String? _errorMessage; // Переменная для хранения сообщения об ошибке
  bool _obscureText = true; // Переменная для обеспечения скрытого и видимого отображения пароля

  @override
  void dispose() {
    // Освобождаем ресурсы контроллеров при удалении виджета
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }
  // Функция _submit для обработки входа/регистрации
  // 1. Валидация формы: Проверяет, заполнены ли поля email и пароль.
  // 2. Индикатор загрузки: Устанавливает isLoading = true, чтобы показать 
  //    пользователю, что идет процесс аутентификации. Сбрасывает сообщение об ошибке.
  // 3. Вход/Регистрация: В зависимости от значения флага isLogin вызывает либо 
  //    signInWithEmailAndPassword (процедура входа), либо createUserWithEmailAndPassword 
  //    (процедура регистрации) из сервиса services/firebase_auth.dart (_authenticationService). 
  //    Если это регистрация, то после успешного создания пользователя отправляется письмо 
  //    на указанную почту для подтверждения email.
  // 4. Переход на главную страницу: После успешного входа/регистрации, проверяется, что mounted 
  //    имеет значение true, и выполняется переход на MainPage.
  // 5. Обработка ошибок: В блоке try...catch отлавливаются ошибки типа FirebaseAuthException 
  //    (ошибки Firebase) и другие исключения. Сообщение об ошибке сохраняется в _errorMessage.
  // 6. Сброс индикатора загрузки: В блоке finally устанавливается isLoading = false, 
  //    чтобы скрыть индикатор загрузки, независимо от результата операции.
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        _errorMessage = null;
      });

      try {
        if (isLogin) {
          // Процедура входе пользователя в Firebase
          await _authenticationService.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        } else {
          // Процедура регистрации пользователя в Firebase
          await _authenticationService.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          // Отправка письма подтверждения после регистрации
          await _authenticationService.sendEmailVerification();
          // Дополнительная обработка после успешной регистрации, например, отображение 
          // сообщения об успешной регистрации
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Регистрация прошла успешно. Письмо подтверждения отправлено.')),
          );
        }

        // Получаем текущего пользователя Firebase
        final user = FirebaseAuth.instance.currentUser;
        String? message;
        if (user != null) {
          // Успешный вход или регистрация 
          // String? displayName = user.displayName; - не используется 
          String? email = user.email;
          message = isLogin ? 'Вы вошли как $email' : 'Вы успешно зарегистрировались как $email';

          if (!isLogin && !user.emailVerified) { // проверка email при регистрации
              message += '\nПожалуйста, подтвердите ваш email.';
          }

        } else {
          // Ошибка аутентификации (user == null)
          message = isLogin 
            ? 'Ошибка входа. Проверьте email и пароль, или зарегистрируйтесь.' 
            : "Ошибка регистрации. Возможно, пользователь с таким email уже существует.";
        }

        // Вызов showDialog в любом случае
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(isLogin ? 'Вход' : 'Регистрация'),
              content: Text(message!), // message не будет null здесь
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    if (user != null && !isLogin && !user.emailVerified) { // проверка email при регистрации
                      _authenticationService.sendEmailVerification(); // повторная отправка письма для верификации
                    }
                    // Переменная mounted указывает, "примонтирован" ли виджет к дереву 
                    // виджетов Flutter. Проверка if (!mounted) return; предотвращает обновление 
                    // состояния виджета, если он уже был удален из дерева, что может привести 
                    // к ошибкам. Это важная проверка перед выполнением асинхронных операций, 
                    // которые могут завершиться после того, как виджет уже не актуален.
                    if (!mounted) return;
                    // Переход на главную страницу после успешного входа/регистрации
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainPage()),
                      );
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      // Обработка ошибок Firebase
      // При ошибках входа/регистрации в Firebase в переменную _errorMessage 
      // записывается сообщение об ошибке, полученное из исключения 
      // FirebaseAuthException (например, "неверный пароль" или "пользователь 
      // не найден"). Если возникла ошибка другого типа, туда записывается общее 
      // сообщение "Произошла ошибка. Попробуйте позже.". Пользователь видит 
      // состояние ошибки благодаря выводу значения _errorMessage в виджете Text 
      // красным цветом. Это происходит после сброса индикатора загрузки.
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Произошла ошибка. Попробуйте позже.';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

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
            child: Form(// Оборачиваем Column в Form
              key: _formKey, // Привязываем ключ к форме
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset( // Картинка размещается "как есть"                
                      //   'assets/ZC.png', // Замените на правильный путь к файлу
                      //   height: 60, // Устанавливаем высоту изображения
                      // ),
                      CircleAvatar( // Картинка размещается в кружочке
                        radius: 30,
                        backgroundImage: AssetImage('assets/ZC.png'), // Замените на путь к вашему аватару
                      ),
                      SizedBox(width: 8),
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
                  // Добавляем текст "DoDidDone"
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            // color: Colors.black.withOpacity(0.5), // Цвет тени (возникает ошибка! 
                            // - Gemini говорит, что не подходит версия Flutter)
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
                            color: DoDidDoneTheme.lightTheme.colorScheme.onPrimary, // Белый
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
                  // Поле эл. почты
                  TextFormField(
                    controller: _emailController, // Подключаем контроллер
                    decoration: const InputDecoration(
                      hintText: 'Почта',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) { // Добавляем валидацию
                      // Необходимо дополнить проверками: знак @ должен встречаться один раз
                      // и не должен находится на месте первого символа 
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите почту';
                      }
                      if (!value.contains('@')) {
                        return 'Пожалуйста, введите корректный email';
                      }
                      return null;
                    },
                  ),
                                  
                  const SizedBox(height: 20),
                  // Поле пароля
                  TextFormField(
                    controller: _passwordController, // Подключаем контроллер
                    obscureText: _obscureText, // Переменная для отображения/скрытия пароля
                    decoration:  InputDecoration(
                      hintText: 'Пароль',
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      // Добавляем суффикс-иконку для переключения видимости
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) { // Добавляем валидацию
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      // if (value.length < 6) {
                      //   return 'Пароль должен быть не менее 6 символов';
                      // }
                      return null;
                    },
                  ),
                                    
                  const SizedBox(height: 20),
                  // ** Новое поле "Повторить пароль"**
                  if (!isLogin) // Отображаем только при регистрации
                    TextFormField(
                      obscureText: _obscureText, // Переменная для отображения/скрытия пароля
                      decoration: InputDecoration(
                        hintText: 'Повторить пароль',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        // Добавляем суффикс-иконку для переключения видимости
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) { // Валидация совпадения паролей
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, повторите пароль';
                        }
                        if (value != _passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                    ),
                                    
                  const SizedBox(height: 30),
                  // Кнопка "Войти" / "Зарегистрироваться"
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit, // Блокируем кнопку во время загрузки
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isLogin
                          ? DoDidDoneTheme.lightTheme.colorScheme.primary
                          : DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading // Отображаем индикатор загрузки или текст
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                  
                  ),
                  const SizedBox(height: 10),
                  // Вывод сообщения об ошибке, если оно есть
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  
                  const SizedBox(height: 20),
                  // Кнопка перехода на другую страницу
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        _errorMessage = null; // Сбрасываем сообщение об ошибке при переключении режима
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
        ),
      ),
    );
  }
}