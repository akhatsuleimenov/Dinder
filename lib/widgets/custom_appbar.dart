import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasActions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasActions = true,
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
                  icon: Icon(Icons.message,
                      color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/matches');
                  }),
              IconButton(
                  icon:
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  })
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.0);
}
