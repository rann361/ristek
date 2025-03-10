
import 'package:flutter/material.dart';
import 'package:ristek/pages/home.dart';
import 'package:ristek/pages/profile_screen.dart';


class HomeNavbar extends StatefulWidget {
  const HomeNavbar({super.key});

  @override
  _HomeNavbarState createState() => _HomeNavbarState();
}

class _HomeNavbarState extends State<HomeNavbar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
                color: _currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
                color: _currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}



