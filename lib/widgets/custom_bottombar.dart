import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
  });

  static const mapping = {
    0: '/',
    1: '/matches',
    2: '/profile',
  };

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Theme.of(context).cardColor),
          label: "Dinder",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble_outline_rounded,
            color: Theme.of(context).cardColor,
          ),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box, color: Theme.of(context).cardColor),
          label: "Profile",
        )
      ],
      backgroundColor: Colors.black,
      onTap: (value) {
        Navigator.pushNamed(context, mapping[value]!);
      },
      // currentIndex: _selectedIndex,
    );
  }
}
