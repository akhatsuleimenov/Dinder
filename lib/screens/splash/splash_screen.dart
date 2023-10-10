import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          return previous.authUser != current.authUser ||
              current.authUser == null;
        },
        listener: (context, state) {
          print("Splash Screen Listener");
          if (state.status == AuthStatus.authenticated) {
            print("pushed HomeScreen");
            Timer(
              const Duration(seconds: 1),
              () => Navigator.of(context).pushNamed(HomeScreen.routeName),
            );
          } else {
            print("pushed LoginScreen");
            Timer(
              const Duration(seconds: 1),
              () => Navigator.pushNamed(
                context,
                LoginScreen.routeName,
                // ModalRoute.withName('/login'),
              ),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'DINDER',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    RepositoryProvider.of<AuthRepository>(context).signOut();
                  },
                  child: Center(
                    child: Text(
                      'Sign Out',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
