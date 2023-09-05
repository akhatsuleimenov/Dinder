import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '/blocs/blocs.dart';
import '../widgets/widgets.dart';

class Info extends StatelessWidget {
  final TabController tabController;

  const Info({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OnboardingLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const CustomTextHeader(text: 'What\'s Your Name?'),
                  const SizedBox(height: 20),
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
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 100,
                  ),
                  const CustomTextHeader(text: 'What\'s Your Age?'),
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
                  const SizedBox(
                    height: 10,
                  ),
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
                ]),
                Column(
                  children: [
                    StepProgressIndicator(
                      totalSteps: 6,
                      currentStep: 3,
                      selectedColor: Theme.of(context).focusColor,
                      unselectedColor: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      tabController: tabController,
                      text: 'NEXT STEP',
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Text("error");
        }
      },
    );
  }
}
