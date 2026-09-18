import 'package:flutter/material.dart';
import 'package:learnx_flutter/presentation/home_page.dart';
import 'package:learnx_flutter/presentation/my_courses_page.dart';
import 'package:learnx_flutter/presentation/favorites_page.dart';
import 'package:learnx_flutter/presentation/profile_page.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      MyCoursesPage(onExploreTap: () => _onTabTapped(0)),
      FavoritesPage(onExploreTap: () => _onTabTapped(0)),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey[500],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarStyleItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: "استكشف",
            ),
            BottomNavigationBarStyleItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: "دوراتي",
            ),
            BottomNavigationBarStyleItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: "المفضلة",
            ),
            BottomNavigationBarStyleItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "حسابي",
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationBarStyleItem extends BottomNavigationBarItem {
  const BottomNavigationBarStyleItem({
    required Widget icon,
    required Widget activeIcon,
    required String label,
  }) : super(icon: icon, activeIcon: activeIcon, label: label);
}
