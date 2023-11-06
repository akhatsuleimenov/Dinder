import 'package:dinder/screens/screens.dart';
import 'package:dinder/services/index_service.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  static const mapping = {
    0: HomeScreen.routeName,
    1: MatchesScreen.routeName,
    2: ProfileScreen.routeName,
  };

  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    IndexService authService = IndexService.instance;
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
        if (authService.selectedIndex != index) {
          // if (authService.selectedIndex == 0) {
          //   Navigator.of(context).pushNamed(mapping[index]!);
          // } else {
          //   if (index == 0) {
          //     Navigator.of(context)
          //         .popUntil(ModalRoute.withName(HomeScreen.routeName));
          //   } else {
          //     Navigator.of(context).pushReplacementNamed(mapping[index]!);
          //   }
          // }
          Navigator.of(context).pushReplacementNamed(mapping[index]!);
          authService.update(index);
        }
      },
      currentIndex: authService.selectedIndex,
    );
  }
}
