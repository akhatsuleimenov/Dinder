import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/repositories/repositories.dart';
import '/screens/screens.dart';
import '/blocs/blocs.dart';
import '/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        print(BlocProvider.of<AuthBloc>(context).state.status);
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const LoginScreen()
            : BlocProvider<SwipeBloc>(
                create: (context) => SwipeBloc(
                  authBloc: context.read<AuthBloc>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                )..add(LoadUsers()),
                child: const HomeScreen(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if (state is SwipeLoading) {
          return const Scaffold(
              appBar: CustomAppBar(
                title: 'Home',
              ),
              bottomNavigationBar: CustomBottomBar(),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        } else if (state is SwipeLoaded) {
          return SwipeLoadedHomeScreen(state: state);
        } else if (state is SwipeMatched) {
          return SwipeMatchedHomeScreen(state: state);
        } else if (state is SwipeError) {
          return Scaffold(
            appBar: const CustomAppBar(
              title: 'Home',
            ),
            bottomNavigationBar: const CustomBottomBar(),
            body: Center(
              child: Text(
                'No more users',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        } else {
          return const Scaffold(
            appBar: CustomAppBar(
              title: 'Home',
            ),
            bottomNavigationBar: CustomBottomBar(),
            body: Center(child: Text("Something went wrong!")),
          );
        }
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
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
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
  });
  final SwipeMatched state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congrats, it\'s a match!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'You and ${state.user.name} have liked each other!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).focusColor,
                          Theme.of(context).primaryColor,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                          context.read<AuthBloc>().state.user!.imageUrls[0]),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).focusColor,
                          Theme.of(context).primaryColor,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(state.user.imageUrls[0]),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              text: 'SEND A MESSAGE',
              textColor: Theme.of(context).primaryColor,
              onPressed: () {},
              beginColor: Colors.white,
              endColor: Colors.white,
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              text: 'BACK TO SWIPING',
              textColor: Colors.white,
              onPressed: () {
                context.read<SwipeBloc>().add(LoadUsers());
              },
              beginColor: Theme.of(context).focusColor,
              endColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
