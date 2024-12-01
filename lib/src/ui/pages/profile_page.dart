import 'package:flutter/material.dart';
import 'package:pr_12/src/models/user_model.dart';
import 'package:pr_12/src/resources/api.dart';
import 'package:pr_12/src/ui/components/profile.dart';
import 'package:pr_12/src/ui/pages/order_page.dart';
import 'package:pr_12/src/ui/pages/profile_without_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  UserFromDB? _userFromDB;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchUser(String email) async {
    try {
      final user = await ApiService().getUser(email);
      setState(() {
        _userFromDB = user;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return ProfileWithoutAuth();
    }
    if (_isLoading) {
      _fetchUser(user.email!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Профиль',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color.fromRGBO(76, 23, 0, 1.0),),
            onPressed: () async {
              await supabase.auth.signOut();
              setState(() {});
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userFromDB == null
          ? const Center(child: Text('Не удалось загрузить данные пользователя'))
          : Column(
        children: [
          Profile(user: _userFromDB!),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EditProfilePage(user: _user!),
              //   ),
              // ).then((updatedUser) {
              //   if (updatedUser != null) {
              //     _updateData(updatedUser);
              //   }
              // });
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(350, 40),
                textStyle: const TextStyle(
                  fontSize: 14,
                )),
            child: const Text('Редактировать профиль'),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderPage(userId: 1),
                ),
              );
            },
            child: Container(
              width: 350,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(129, 40, 0, 1),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: const Center(
                child: Text('Мои заказы >>', style:
                  TextStyle(
                    color: Color.fromRGBO(129, 40, 0, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
