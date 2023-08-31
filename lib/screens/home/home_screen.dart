import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/swipe/swipe_bloc.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Home',
        ),
        body: BlocBuilder<SwipeBloc, SwipeState>(
          builder: (context, state) {
            if (state is SwipeLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SwipeLoaded) {
              return Column(
                children: [
                  InkWell(
                    onDoubleTap: () {
                      Navigator.pushNamed(context, '/users',
                          arguments: state.users[0]);
                    },
                    child: Draggable(
                      feedback: UserCard(user: state.users[0]),
                      childWhenDragging: UserCard(
                        user: state.users[1],
                      ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 60),
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
                          child: ChoiceButton(
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
              );
            } else {
              return Text("Something went wrong!");
            }
          },
        ),
        bottomNavigationBar: CustomBottomBar());
  }
}
