import 'package:dinder/cubits/cubit/signup_cubit.dart';
import 'package:dinder/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_screens.dart/screens.dart';
import '../../widgets/custom_appbar.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: OnboardingScreen(),
      ),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    Tab(text: 'EmailVerifciation'),
    Tab(text: 'Info'),
    Tab(text: 'Pictures'),
    Tab(text: 'Bio'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'DINDER',
          ),
          body: TabBarView(children: [
            Start(tabController: tabController),
            Email(tabController: tabController),
            EmailVerification(tabController: tabController),
            Info(tabController: tabController),
            Pictures(tabController: tabController),
            Bio(tabController: tabController),
          ]),
        );
      }),
    );
  }
}
