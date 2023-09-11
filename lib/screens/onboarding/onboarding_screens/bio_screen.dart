import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/screens.dart';
import '/blocs/blocs.dart';
import '../widgets/widgets.dart';

class Bio extends StatelessWidget {
  const Bio({
    super.key,
    required this.state,
  });
  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 5,
      onPressed: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
      children: [
        const CustomTextHeader(text: 'Tell Me Who R U?'),
        CustomTextField(
          hint: 'BIO HERE',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(bio: value),
                  ),
                );
          },
        ),
        const SizedBox(height: 10),
        const CustomTextHeader(text: 'What Is Your Major?'),
        CustomTextField(
          hint: 'Major',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(major: value),
                  ),
                );
          },
        ),
        const SizedBox(height: 50),
        const CustomTextHeader(text: 'What Do You Like?'),
        const Row(
          children: [
            CustomTextContainer(text: 'Music'),
            CustomTextContainer(text: 'Art'),
            CustomTextContainer(text: 'Sports'),
            CustomTextContainer(text: 'Chess'),
          ],
        ),
      ],
    );
  }
}
