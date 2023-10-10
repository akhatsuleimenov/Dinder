import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/screens.dart';
import '../widgets/widgets.dart';
import '/blocs/blocs.dart';

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.state,
  });
  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 3,
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
      },
      children: [
        const CustomTextHeader(text: 'What\'s Your Name?'),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'ENTER YOUR NAME',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(name: value),
                  ),
                );
          },
        ),
        const CustomTextHeader(text: 'What\'s Your Gender?'),
        const SizedBox(height: 10),
        CustomCheckbox(
          text: 'MALE',
          value: state.user.gender == 'Male',
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(gender: 'Male'),
                  ),
                );
          },
        ),
        CustomCheckbox(
          text: 'FEMALE',
          value: state.user.gender == 'Female',
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(gender: 'Female'),
                  ),
                );
          },
        ),
        const CustomTextHeader(text: 'What\'s Your Age?'),
        const SizedBox(height: 10),
        CustomTextField(
          hint: 'ENTER YOUR AGE',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(age: int.parse(value)),
                  ),
                );
          },
        ),
        const CustomTextHeader(text: 'Are you a giver or receiver?'),
        const SizedBox(height: 10),
        CustomCheckbox(
          text: 'GIVER',
          value: state.user.giver == true,
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(giver: true),
                  ),
                );
          },
        ),
        CustomCheckbox(
          text: 'RECEIVER',
          value: state.user.giver == false,
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(giver: false),
                  ),
                );
          },
        ),
      ],
    );
  }
}
