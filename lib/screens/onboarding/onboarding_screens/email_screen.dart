import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/cubits/cubits.dart';
import '../widgets/widgets.dart';
import '/screens/screens.dart';

class Email extends StatelessWidget {
  const Email({
    super.key,
    required this.state,
  });
  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 2,
      onPressed: () async {
        await context.read<SignupCubit>().signUpWithCredentials();
        context.read<OnboardingBloc>().add(
              ContinueOnboarding(
                isSignup: true,
                user: User.empty.copyWith(
                  id: context.read<SignupCubit>().state.user!.uid,
                ),
              ),
            );
      },
      children: [
        const CustomTextHeader(text: 'What\'s your email address?'),
        CustomTextField(
          hint: 'ENTER YOUR EMAIL',
          onChanged: (value) {
            context.read<SignupCubit>().emailChanged(value);
          },
        ),
        const SizedBox(height: 100),
        const CustomTextHeader(text: 'Choose a Password'),
        CustomTextField(
          hint: 'ENTER YOUR PASSWORD',
          onChanged: (value) {
            context.read<SignupCubit>().passwordChanged(value);
          },
        ),
      ],
    );
  }
}
