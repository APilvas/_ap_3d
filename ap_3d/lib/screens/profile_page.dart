// Страница профиля пользователя. Версия 18.11.2024 
// Изображение и эл.почта пользователя задаются в тексте программы
// Диалог проверки почты
// Кнопка выхода со страницы профиля - возврат на страницу Main 

import 'package:ap_3d/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Импорт FirebaseAuth
import 'package:ap_3d/services/firebase_auth.dart'; // Импорт вашей AuthenticationService
import 'package:flutter/material.dart';

import 'package:ap_3d/theme/theme.dart';
import '../pages/main_page.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authenticationService = AuthenticationService(); // Экземпляр AuthenticationService
  User? _user; // Firebase User object

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser; // Get current user
  }


  @override
  Widget build(BuildContext context) {
    // Get user information. Display default if user or user email is null.

    String? userEmail = _user?.email ?? 'user@example.com';
    String? userPhotoURL = _user?.photoURL; // Get user photo URL
    bool isEmailVerified = _user?.emailVerified ?? false; // Check verification status


    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           CircleAvatar( // Display user's avatar or default
            radius: 60,
            backgroundImage: userPhotoURL != null 
            ? NetworkImage(userPhotoURL) 
            : const AssetImage('assets/user8.png') as ImageProvider,
          ),
          const SizedBox(height: 20),
          Text(
            userEmail,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Показывать кнопку проверки, если адрес электронной почты не подтвержден
          if (_user != null && !isEmailVerified) ...[ // Show verify button if email not verified
            ElevatedButton(
              onPressed: () async {
                // Отправить письмо с подтверждением и показать диалоговое окно
                // Send verification email and show dialog
                await _user?.sendEmailVerification();  // Use _user?. to handle null user case
                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('Подтверждение почты'),
                    content: Text('Письмо с подтверждением отправлено на адрес $userEmail.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage())
                        ),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Подтвердить почту',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Кнопка выхода из старницы профиля
          ElevatedButton( // Sign out button
            onPressed: () async {
              // Возврат на страницу LoginPage ()
              await _authenticationService.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage())
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Красный цвет для кнопки выхода
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Выйти',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}


// // Страница профиля пользователя. Версия 22.09.2024 
// // Изображение и эл.почта задаются в тексте программы
// // Диалог проверки почты
// // Кнопка выхода со страницы профиля - возврат на страницу Main 

// import 'package:flutter/material.dart';
// import 'package:ap_3d/theme/theme.dart';

// import '../pages/main_page.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool isEmailVerified = false; // Флаг подтверждения почты (по умолчанию false)

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircleAvatar(
//                   radius: 60,
//                   backgroundImage: AssetImage('assets/user8.png'), // Замените на путь к вашему аватару
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'user@example.com', // Замените на почту пользователя
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 const SizedBox(height: 10),
//                 if (!isEmailVerified) ...[
//                   // Отображаем кнопку подтверждения, если почта не подтверждена
//                   ElevatedButton(
//                     onPressed: () {
//                     // Отработка запроса на подтверждение почты пользователя
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                         backgroundColor: Colors.white,
//                         title: const Text('Подтверждение почты'),
//                         content: const Text('Письмо с подтверждением отправлено на ваш адрес.'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('OK'),
//                             ),
//                           ],
//                         ),
//                         );
//                       //setState(() {
//                       //  isEmailVerified = true;
//                       //});
//                     },
//                     style: ElevatedButton.styleFrom(
//                       //backgroundColor: APTheme.lightTheme.colorScheme.secondary,
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                       textStyle: const TextStyle(fontSize: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       'Подтвердить почту',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//                 // Кнопка выхода из старницы профиля
//                 ElevatedButton(
//                   onPressed: () {
//                     // Возврат на страницу MainPage ()
//                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return const MainPage();}));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red, // Красный цвет для кнопки выхода
//                     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                     textStyle: const TextStyle(fontSize: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: const Text(
//                     'Выйти',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           );
        
    
//   }
// }
