import 'package:dinder/models/user_model.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  final User user;
  const UsersScreen({super.key, required this.user});

  static const String routeName = '/users';

  static Route route({required User user}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => UsersScreen(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Hero(
                    tag: 'user_image',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(user.imageUrls[0]),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name}, ${user.age}',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  user.major,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  user.bio,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(height: 2, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Text(
                //   'Interests',
                //   style: Theme.of(context).textTheme.displayMedium,
                // ),
                // Row(
                //   children: user.interests
                //       .map((interest) => Container(
                //             padding: const EdgeInsets.all(5),
                //             margin: const EdgeInsets.only(top: 5, right: 5),
                //             decoration: BoxDecoration(
                //                 gradient: LinearGradient(colors: [
                //               Theme.of(context).primaryColor,
                //               Theme.of(context).scaffoldBackgroundColor,
                //             ])),
                //             child: Text(
                //               interest,
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .headlineMedium
                //                   ?.copyWith(
                //                       fontWeight: FontWeight.normal,
                //                       color: Colors.white),
                //             ),
                //           ))
                //       .toList(),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
