import 'package:flutter/material.dart';
import 'package:mbanking_app_flutter/components/card_screen.dart';
import 'package:mbanking_app_flutter/home_screen.dart' as home;
import 'package:mbanking_app_flutter/components/profile_screen.dart' as profile;
import 'package:mbanking_app_flutter/page/welcome.dart'; // Import welcome screen dari folder page
import 'package:mbanking_app_flutter/page/account.dart'; // Import account screen dari folder page

void main() {
  runApp(const MbankingApp());
}

class MbankingApp extends StatelessWidget {
  const MbankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mbanking App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      // Ubah home menjadi WelcomeScreen
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      // Tambahkan routes untuk navigasi
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const home.HomeScreen(),
    const CardScreen(),
    const profile.ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.indigo[200],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
