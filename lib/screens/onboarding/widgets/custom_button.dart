import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/user_model.dart';
import '/blocs/blocs.dart';
import '/cubits/cubits.dart';

class CustomButton extends StatelessWidget {
  final TabController tabController;
  final String text;

  const CustomButton({
    super.key,
    required this.tabController,
    this.text = 'START',
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(colors: [
          Theme.of(context).focusColor,
          Theme.of(context).primaryColor,
        ]),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: Colors.transparent),
        onPressed: () async {
          if (tabController.index == 4) {
            Navigator.pushNamed(context, '/');
          } else {
            tabController.animateTo(tabController.index + 1);
          }
          if (tabController.index == 2) {
            await context.read<SignupCubit>().signUpWithCredentials();
            User user = User(
              id: context.read<SignupCubit>().state.user!.uid,
              name: '',
              age: 0,
              gender: '',
              imageUrls: [],
              major: '',
              interests: [],
              bio: '',
              giver: 'false',
              swipeLeft: [],
              swipeRight: [],
              matches: [],
            );
            context.read<OnboardingBloc>().add(
                  StartOnboarding(
                    user: user,
                  ),
                );
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
