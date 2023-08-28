import '../../models/models.dart';
import '../../widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    final User user = User.users[0];
    return Scaffold(
      appBar: const CustomAppBar(title: 'PROFILE'),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(3, 3),
                      blurRadius: 3,
                      spreadRadius: 3,
                    ),
                  ],
                  image: DecorationImage(
                      image: NetworkImage(user.imageUrls[0]),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).focusColor.withOpacity(0.1),
                      Theme.of(context).focusColor.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Text(
                      user.name,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWithIcon(title: 'Biography', icon: Icons.edit),
                Text(
                  user.bio,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 2),
                ),
                TitleWithIcon(title: 'Pictures', icon: Icons.edit),
                SizedBox(
                  height: 125,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          height: 125,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Theme.of(context).focusColor),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(user.imageUrls[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TitleWithIcon(title: 'Location', icon: Icons.edit),
                Text(
                  'Random Location',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 2),
                ),
                TitleWithIcon(title: 'Interest', icon: Icons.edit),
                Row(
                  children: [
                    CustomTextContainer(text: 'MUSIC'),
                    CustomTextContainer(text: 'COMPUTER'),
                    CustomTextContainer(text: 'VOLLEYBALL'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TitleWithIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  const TitleWithIcon({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        IconButton(onPressed: () {}, icon: Icon(icon))
      ],
    );
  }
}
