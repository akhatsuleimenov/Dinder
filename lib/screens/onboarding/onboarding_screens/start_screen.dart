import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset('assets/logo.svg'),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          'Welcome to Dinder',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Text(
          'Generating long and coherent text is an important but challenging task, particularly for open-ended language generation tasks such as story generation.',
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
