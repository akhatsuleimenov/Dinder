import 'package:flutter/material.dart';

import '/widgets/widgets.dart';
import 'onboarding_screens/screens.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => OnboardingScreen(),
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
        final TabController tabController = DefaultTabController.of(context);
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
