import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/screens.dart';
import '/blocs/blocs.dart';

class Start extends StatelessWidget {
  const Start({
    super.key,
    required this.state,
  });
  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 1,
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
      },
      children: [
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset('assets/logo.png'),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Text(
            'Welcome to Dinder',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Text(
          'From now on you will never run out of Meal Swipes and will always have a friend to enjoy the meal with',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
