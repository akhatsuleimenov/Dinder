import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/screens.dart';
import '/repositories/repositories.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class MatchesScreen extends StatelessWidget {
  static const String routeName = '/matches';

  const MatchesScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<MatchBloc>(
        create: (context) =>
            MatchBloc(databaseRepository: context.read<DatabaseRepository>())
              ..add(LoadMatches(user: context.read<AuthBloc>().state.user!)),
        child: const MatchesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'MATCHES'),
      bottomNavigationBar: const CustomBottomBar(),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MatchLoaded) {
            final inactiveMatches = state.matches
                .where((match) => match.chat.messages.isEmpty)
                .toList();
            final activeMatches = state.matches
                .where((match) => match.chat.messages.isNotEmpty)
                .toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Likes',
                        style: Theme.of(context).textTheme.displayMedium),
                    inactiveMatches.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Go back to swiping"),
                          )
                        : MatchesList(inactiveMatches: inactiveMatches),
                    const SizedBox(height: 10),
                    Text(
                      'Your Chats',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    ChatsList(activeMatches: activeMatches)
                  ],
                ),
              ),
            );
          } else if (state is MatchUnavailable) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No matches yet.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    text: 'BACK TO SWIPING',
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    beginColor: Theme.of(context).primaryColor,
                    endColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }
        },
      ),
    );
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({
    super.key,
    required this.activeMatches,
  });

  final List<Match> activeMatches;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activeMatches.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatScreen.routeName,
              arguments: activeMatches[index],
            );
          },
          child: Row(
            children: [
              UserImage.small(
                margin: const EdgeInsets.only(top: 10, right: 10),
                height: 70,
                width: 70,
                url: activeMatches[index].matchUser.imageUrls[0],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeMatches[index].matchUser.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    activeMatches[index].chat.messages[0].message,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    activeMatches[index].chat.messages[0].timeString,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class MatchesList extends StatelessWidget {
  const MatchesList({
    super.key,
    required this.inactiveMatches,
  });

  final List<Match> inactiveMatches;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: inactiveMatches.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatScreen.routeName,
                  arguments: inactiveMatches[index],
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 10),
                child: Column(
                  children: [
                    UserImage.small(
                      height: 70,
                      width: 70,
                      url: inactiveMatches[index].matchUser.imageUrls[0],
                    ),
                    Text(
                      inactiveMatches[index].matchUser.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
