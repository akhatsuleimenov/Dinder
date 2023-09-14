import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
        if (BlocProvider.of<SignupCubit>(context).state.status ==
            FormzStatus.valid) {
          await context.read<SignupCubit>().signUpWithCredentials();
          context.read<OnboardingBloc>().add(
                ContinueOnboarding(
                  isSignup: true,
                  user: User.empty.copyWith(
                    id: context.read<SignupCubit>().state.user!.uid,
                  ),
                ),
              );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check your email and password'),
            ),
          );
        }
      },
      children: [
        const CustomTextHeader(text: 'What\'s your email address?'),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) {
            return CustomTextField(
              hint: 'ENTER YOUR EMAIL',
              errorText: state.email.invalid ? 'The email is invalid.' : null,
              onChanged: (value) {
                context.read<SignupCubit>().emailChanged(value);
              },
            );
          },
        ),
        const SizedBox(height: 100),
        const CustomTextHeader(text: 'Choose a Password'),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) =>
              previous.password != current.password,
          builder: (context, state) {
            return CustomTextField(
              hint: 'ENTER YOUR PASSWORD',
              errorText: state.password.invalid
                  ? 'The password must be at least 8 characters, at least 1 number, at least 1 letter, and no spaces'
                  : null,
              onChanged: (value) {
                context.read<SignupCubit>().passwordChanged(value);
              },
            );
          },
        ),
      ],
    );
  }
}
