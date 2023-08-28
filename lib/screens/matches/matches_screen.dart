import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/user_image.dart';
import '../../widgets/widgets.dart';

class MatchesScreen extends StatelessWidget {
  static const String routeName = '/matches';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MatchesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inactiveMatches = UserMatch.matches
        .where((match) => match.userId == 1 && match.chat!.isEmpty)
        .toList();
    final activeMatches = UserMatch.matches
        .where((match) => match.userId == 1 && match.chat!.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Matches'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Likes',
                  style: Theme.of(context).textTheme.displayMedium),
              SizedBox(
                height: 110,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: inactiveMatches.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          UserImage.small(
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            height: 70,
                            width: 70,
                            url:
                                inactiveMatches[index].matchedUser.imageUrls[0],
                          ),
                          Text(
                            inactiveMatches[index].matchedUser.name,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      );
                    }),
              ),
              const SizedBox(height: 10),
              Text(
                'Your Chats',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: activeMatches.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/chat',
                            arguments: activeMatches[index]);
                      },
                      child: Row(
                        children: [
                          UserImage.small(
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            height: 70,
                            width: 70,
                            url: activeMatches[index].matchedUser.imageUrls[0],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeMatches[index].matchedUser.name,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                activeMatches[index]
                                    .chat![0]
                                    .messages[0]
                                    .message,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                activeMatches[index]
                                    .chat![0]
                                    .messages[0]
                                    .timeString,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
