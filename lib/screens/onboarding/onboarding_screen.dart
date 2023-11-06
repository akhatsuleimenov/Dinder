import 'package:dinder/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/repositories/repositories.dart';
import 'onboarding_screens/screens.dart';
import 'widgets/widgets.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<SignupCubit>(
            create: (context) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<OnboardingBloc>(
            create: (context) => OnboardingBloc(
              databaseRepository: context.read<DatabaseRepository>(),
              storageRepository: context.read<StorageRepository>(),
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
        final TabController tabController = DefaultTabController.of(context);
        context
            .read<OnboardingBloc>()
            .add(StartOnboarding(tabController: tabController));
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'DINDER',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 50,
            ),
            child: BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                if (state is OnboardingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is OnboardingLoaded) {
                  return TabBarView(
                    children: [
                      Start(state: state),
                      Email(state: state),
                      Info(state: state),
                      Pictures(state: state),
                      Bio(state: state),
                    ],
                  );
                } else {
                  return const Text('Something went wrong.');
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

class OnboardingScreenLayout extends StatelessWidget {
  final List<Widget> children;
  final int currentStep;
  final void Function()? onPressed;

  const OnboardingScreenLayout({
    Key? key,
    required this.children,
    required this.currentStep,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...children,
                  const Spacer(),
                  SizedBox(
                    height: 75,
                    child: Column(
                      children: [
                        StepProgressIndicator(
                          totalSteps: 5,
                          currentStep: currentStep,
                          selectedColor: Theme.of(context).primaryColor,
                          unselectedColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        const SizedBox(height: 10),
                        CustomElevatedButton(
                          text: 'NEXT STEP',
                          textColor: Colors.white,
                          onPressed: onPressed,
                          color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
