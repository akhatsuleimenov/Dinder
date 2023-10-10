import 'package:flutter/material.dart';

int _selectedIndex = 0;

class CustomBottomBar extends StatelessWidget {
  static const mapping = {
    0: '/',
    1: '/matches',
    2: '/profile',
  };

  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      selectedItemColor: Theme.of(context).primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Theme.of(context).hintColor),
          label: "Dinder",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble_outline_rounded,
            color: Theme.of(context).hintColor,
          ),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box, color: Theme.of(context).hintColor),
          label: "Profile",
        )
      ],
      backgroundColor: Colors.white,
      onTap: (index) {
        if (_selectedIndex != index) {
          Navigator.pushNamed(context, mapping[index]!);
          _selectedIndex = index;
        }
      },
      currentIndex: _selectedIndex,
    );
  }
}
