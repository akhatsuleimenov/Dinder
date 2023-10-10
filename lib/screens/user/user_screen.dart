import 'package:dinder/blocs/auth/auth_bloc.dart';
import 'package:dinder/blocs/swipe/swipe_bloc.dart';
import 'package:dinder/repositories/database/database_repository.dart';
import 'package:dinder/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/widgets.dart';

class UsersScreen extends StatelessWidget {
  // final User user;
  // final bool action;
  final ScreenArguments args;
  const UsersScreen({super.key, required this.args});

  static const String routeName = '/users';

  static Route route({required ScreenArguments args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (context) => SwipeBloc(
          authBloc: context.read<AuthBloc>(),
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(LoadUsers()),
        child: UsersScreen(args: args),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final swipeBloc = BlocProvider.of<SwipeBloc>(context);

    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if (state is SwipeLoading) {
          return const CircularProgressIndicator();
        } else if (state is SwipeMatched) {
          print('SwipeMatchedHomeScreen');
          return SwipeMatchedHomeScreen(
              state: state,
              onPressed: () {
                context.read<SwipeBloc>().add(LoadUsers());
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              });
        } else if (state is SwipeLoaded) {
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
                                  image: NetworkImage(args.user.imageUrls[0]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      args.action == true
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // swipeBloc.add(SwipeLeft(user: args.user));
                                        print("HEEeeeeere");
                                        context.read<SwipeBloc>().add(
                                            SwipeLeft(user: state.users[0]));
                                        Navigator.of(context).pushNamed('/');
                                      },
                                      child: ChoiceButton(
                                          color: Theme.of(context).primaryColor,
                                          icon: Icons.clear_rounded),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // swipeBloc.add(SwipeRight(user: args.user));
                                        print("HEEeeeeere");
                                        context.read<SwipeBloc>().add(
                                            SwipeRight(user: state.users[0]));
                                        // Navigator.of(context).pushNamed('/');
                                      },
                                      child: const ChoiceButton(
                                          width: 80,
                                          height: 80,
                                          size: 30,
                                          color: Colors.white,
                                          hasGradient: true,
                                          icon: Icons.favorite),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(height: 0),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${args.user.name}, ${args.user.age}',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        args.user.major,
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
                        args.user.bio,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                                height: 2, fontWeight: FontWeight.normal),
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
        } else {
          return Scaffold(
            appBar: AppBar(
              // elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          );
        }
      },
    );
  }
}
