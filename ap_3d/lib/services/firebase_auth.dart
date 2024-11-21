import 'package:firebase_auth/firebase_auth.dart';

/// Сервис для работы с авторизацией Firebase.
class AuthenticationService {
  // Инициализация экземпляра Firebase Authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // Аутентифицирует пользователя с помощью электронной почты и пароля.
  // Метод для входа с помощью email и пароля
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Вход в Firebase с помощью email и пароля
      //return await _firebaseAuth.signInWithEmailAndPassword(
      //  email: email, password: password);
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;

    } on FirebaseAuthException catch (e) {
      // Обработка ошибок авторизации с помощью email и пароля.
      print('Ошибка при входе с помощью email и пароля: ${e.code}');
      return null;
    }
  }
  // Метод для регистрации с помощью email и пароля
    Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Создает в firebase нового пользователя с помощью email и пароля.
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок регистрации.
      print('Ошибка регистрации: ${e.code}');
      return null;
    }
  }
  // Метод для отправки запроса подтверждения email
  Future<void> sendEmailVerification() async {
    try {
      // Получает текущего пользователя Firebase
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      // Обработка ошибок отправки письма.
      print('Ошибка при отправке запроса подтверждения почты: ${e.toString()}');
    }
  }
  
  // Метод выхода из системы
  Future<void> signOut() async {
    try {
      // Выход из системы Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      // Обработка ошибок выхода из системы.
      print('Ошибка при выходе из системы: ${e.toString()}');
    }
  }
  
  // Получкение текущего пользователя
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

