import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/main.dart';
import 'package:pr_12/src/models/user_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final nickname = nicknameController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty || password.isEmpty || nickname.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
      );
        final newUser = UserFromDB (
              userId: 0,
              username: nickname,
              email: email,
              password: password,
              image: '',
              phone: phone
        );
        await _sendAdditionalData(user: newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Регистрация успешна!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка регистрации: $e')),
      );
    }
  }

  Future<void> _sendAdditionalData({
    required UserFromDB user,
  }) async {
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        'https://$url:8080/register',
        data: user.toJson()
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Данные успешно отправлены на бэкенд');
      } else {
        throw Exception('Ошибка при отправке данных: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      final errorMessage = e.response != null
          ? e.response?.data.toString()
          : e.message;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки данных: $errorMessage')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Регистрация',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(labelText: 'Никнейм'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Телефон'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
