import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/screens/screens.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasAction;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasAction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SvgPicture.asset(
              'assets/logo.svg',
              height: 35,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: hasAction ? 10 : 0),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            width: hasAction ? 0 : 40,
          ),
        ],
      ),
      actions: [
        hasAction
            ? IconButton(
                icon: Icon(
                  title == "PROFILE" ? Icons.settings : Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(title == "PROFILE"
                      ? SettingsScreen.routeName
                      : ProfileScreen.routeName);
                },
              )
            : Container(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40.0);
}
