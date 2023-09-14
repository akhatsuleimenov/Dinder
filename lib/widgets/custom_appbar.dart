import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/screens/screens.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasActions;
  final List<IconData> actionIcons;
  final List<String> actionRoutes;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasActions = true,
    this.actionIcons = const [Icons.message, Icons.person],
    this.actionRoutes = const [
      MatchesScreen.routeName,
      ProfileScreen.routeName
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child: SvgPicture.asset(
                'assets/logo.svg',
                height: 35,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Theme.of(context).focusColor),
            ),
          ),
        ],
      ),
      actions: hasActions
          ? [
              IconButton(
                  icon: Icon(actionIcons[0],
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pushNamed(context, actionRoutes[0]);
                  }),
              IconButton(
                  icon: Icon(actionIcons[1],
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pushNamed(context, actionRoutes[1]);
                  }),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40.0);
}
