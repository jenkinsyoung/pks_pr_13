import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_12/src/ui/pages/basket_page.dart';
import 'package:pr_12/src/ui/pages/favorite_page.dart';
import 'package:pr_12/src/ui/pages/home_page.dart';
import 'package:pr_12/src/ui/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
  await Supabase.initialize(
      url: 'https://pxebqdevfyhznspqkvmp.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4ZWJxZGV2Znloem5zcHFrdm1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEzOTQzMDksImV4cCI6MjA0Njk3MDMwOX0.H_3nRXcVbsVnKJDv7wAnFto_dDxN-hLQwaJyC4mnFhc'
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(76, 23, 0, 1.0)),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoSansTextTheme(
              Theme.of(context).textTheme
          )
      ),
      home: const MainPage()
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    FavoritePage(),
    BasketPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded,
              color: Color.fromRGBO(76, 23, 0, 1.0),),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded,
              color: Color.fromRGBO(76, 23, 0, 1.0),),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
              color: Color.fromRGBO(76, 23, 0, 1.0),),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
              color: Color.fromRGBO(76, 23, 0, 1.0),),
            label: 'Профиль',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(76, 23, 0, 1.0),
        onTap: _onItemTapped,
      ),
    );
  }
}
