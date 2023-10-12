import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';

bool globalGiver = false;

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print(BlocProvider.of<AuthBloc>(context).state.status);
        // Timer(const Duration(seconds: 2), () {
        //   print(
        //       "HEEEEERE : ${BlocProvider.of<AuthBloc>(context).state.status}");
        // });
        // Future.delayed(Duration(seconds: 2), () {
        //   return;
        // });
        return const HomeScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.authenticated
            ? MultiBlocProvider(
                providers: [
                  BlocProvider<SwipeBloc>(
                    create: (context) => SwipeBloc(
                      authBloc: context.read<AuthBloc>(),
                      databaseRepository: context.read<DatabaseRepository>(),
                    )..add(LoadUsers()),
                  ),
                  BlocProvider<ProfileBloc>(
                    create: (context) => ProfileBloc(
                      authBloc: context.read<AuthBloc>(),
                      databaseRepository: context.read<DatabaseRepository>(),
                    )..add(
                        LoadProfile(
                          userId: context.read<AuthBloc>().state.authUser?.uid,
                        ),
                      ),
                  ),
                ],
                child: BlocBuilder<SwipeBloc, SwipeState>(
                  builder: (context, state) {
                    if (state is SwipeLoading) {
                      print('SwipeLoading');
                      return const Scaffold(
                          appBar: CustomAppBar(
                            title: 'HOME',
                          ),
                          bottomNavigationBar: CustomBottomBar(),
                          body: Center(
                            child: CircularProgressIndicator(),
                          ));
                    } else if (state is SwipeLoaded) {
                      print('SwipeLoadedHomeScreen');
                      return SwipeLoadedHomeScreen(state: state);
                    } else if (state is SwipeMatched) {
                      print('SwipeMatchedHomeScreen');
                      return SwipeMatchedHomeScreen(
                        state: state,
                        onPressed: () {
                          context.read<SwipeBloc>().add(LoadUsers());
                        },
                      );
                    } else if (state is SwipeError) {
                      print('SwipeError');
                      return Scaffold(
                        appBar: const CustomAppBar(
                          title: 'HOME',
                        ),
                        bottomNavigationBar: const CustomBottomBar(),
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No more users',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: SwitchExample(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Scaffold(
                        appBar: CustomAppBar(title: 'HOME'),
                        bottomNavigationBar: CustomBottomBar(),
                        body: Center(child: Text("Something went wrong!")),
                      );
                    }
                  },
                ),
              )
            : const LoginScreen();
      },
    );
  }
}

class SwipeLoadedHomeScreen extends StatelessWidget {
  const SwipeLoadedHomeScreen({
    super.key,
    required this.state,
  });
  final SwipeLoaded state;

  @override
  Widget build(BuildContext context) {
    var userCount = state.users.length;
    print("Inside SwipeLoadedHomeScreen");
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'HOME',
      ),
      bottomNavigationBar: const CustomBottomBar(),
      body: Column(
        children: [
          InkWell(
            onDoubleTap: () {
              Navigator.pushNamed(context, '/users', arguments: state.users[0]);
            },
            child: Draggable(
              feedback: UserCard(user: state.users[0]),
              childWhenDragging: (userCount > 1)
                  ? UserCard(user: state.users[1])
                  : Container(),
              onDragEnd: (drag) {
                if (drag.velocity.pixelsPerSecond.dx < 0) {
                  context
                      .read<SwipeBloc>()
                      .add(SwipeLeft(user: state.users[0]));
                } else {
                  context
                      .read<SwipeBloc>()
                      .add(SwipeRight(user: state.users[0]));
                }
              },
              child: UserCard(
                user: state.users[0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    context
                        .read<SwipeBloc>()
                        .add(SwipeLeft(user: state.users[0]));
                  },
                  child: ChoiceButton(
                    width: 60,
                    height: 60,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                    hasGradient: false,
                    icon: Icons.clear_rounded,
                  ),
                ),
                const SwitchExample(),
                InkWell(
                  onTap: () {
                    context
                        .read<SwipeBloc>()
                        .add(SwipeRight(user: state.users[0]));
                  },
                  child: const ChoiceButton(
                    width: 60,
                    height: 60,
                    size: 30,
                    color: Colors.white,
                    hasGradient: true,
                    icon: Icons.favorite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeMatchedHomeScreen extends StatelessWidget {
  const SwipeMatchedHomeScreen({
    super.key,
    required this.state,
    required this.onPressed,
  });
  final SwipeMatched state;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'It\'s a match!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 60),
            ),
            const SizedBox(height: 20),
            Text(
              'You and ${state.user.name} have liked each other!',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ProfilePicCircle(
                    imageURL:
                        context.read<AuthBloc>().state.user!.imageUrls[0]),
                const SizedBox(width: 10),
                _ProfilePicCircle(imageURL: state.user.imageUrls[0]),
              ],
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              text: 'BACK TO SWIPING',
              textColor: Colors.white,
              onPressed: onPressed,
              beginColor: Theme.of(context).primaryColor,
              endColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePicCircle extends StatelessWidget {
  const _ProfilePicCircle({
    required this.imageURL,
  });

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(imageURL),
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({
    Key? key,
  }) : super(key: key);
  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    // 1. Using Timer
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
// 2. Future.delayed
    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    print("Isloading is: $_isLoading");
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return _isLoading
            ? const CircularProgressIndicator()
            : AnimatedToggleSwitch.dual(
                // // This bool value toggles the switch.
                // value: light,
                // activeColor: CupertinoColors.activeBlue,
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.

                  setState(() {
                    // widget.giver = value;
                    globalGiver = value;
                  });
                  // state as ProfileLoaded;
                  print("Before UpdateUserProfile: ${state.user}");
                  context.read<ProfileBloc>().add(
                        UpdateUserProfile(
                          user: state.user.copyWith(
                            giver: value,
                          ),
                        ),
                      );
                  print("After UpdateUserProfile: ${state.user}");
                  context.read<ProfileBloc>().add(
                        SaveProfile(user: state.user),
                      );
                },
                current: (state as ProfileLoaded).user.giver,
                first: true,
                second: false,
                iconBuilder: (value) => value
                    ? const Icon(Icons.fastfood)
                    : const Icon(Icons.no_food),
                textBuilder: (value) => value
                    ? Center(
                        child: Text(
                        'GIVE',
                        style: Theme.of(context).textTheme.displaySmall,
                      ))
                    : Center(
                        child: Text(
                          'GET',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                style: ToggleStyle(
                  indicatorColor: Theme.of(context).primaryColor,
                  backgroundGradient: LinearGradient(
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).primaryColor,
                    ],
                  ),
                  borderColor: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withAlpha(50),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
