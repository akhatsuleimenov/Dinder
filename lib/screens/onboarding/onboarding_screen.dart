import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/repositories/repositories.dart';
import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/widgets/widgets.dart';

import 'onboarding_screens/screens.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<SignupCubit>(
            create: (_) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<OnboardingBloc>(
            create: (_) => OnboardingBloc(
              databaseRepository: DatabaseRepository(),
              storageRepository: StorageRepository(),
            )..add(
                StartOnboarding(),
              ),
          ),
        ],
        child: const OnboardingScreen(),
      ),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    Tab(text: 'Info'),
    Tab(text: 'Pictures'),
    Tab(text: 'Bio'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'DINDER',
            hasActions: false,
          ),
          body: TabBarView(
            children: [
              Start(tabController: tabController),
              Email(tabController: tabController),
              Info(tabController: tabController),
              Pictures(tabController: tabController),
              Bio(tabController: tabController),
            ],
          ),
        );
      }),
    );
  }
}
