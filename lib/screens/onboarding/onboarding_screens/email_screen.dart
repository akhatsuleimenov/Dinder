import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '/cubits/cubits.dart';
import '../widgets/widgets.dart';

class Email extends StatelessWidget {
  final TabController tabController;

  const Email({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomTextHeader(text: 'What\'s your email address?'),
                CustomTextField(
                  hint: 'ENTER YOUR EMAIL',
                  onChanged: (value) {
                    context.read<SignupCubit>().emailChanged(value);
                    logger.i(state.email);
                  },
                ),
                SizedBox(height: 100),
                CustomTextHeader(text: 'Choose a Password'),
                CustomTextField(
                    hint: 'ENTER YOUR PASSWORD',
                    onChanged: (value) {
                      context.read<SignupCubit>().passwordChanged(value);
                      logger.i(state.password);
                    }),
              ]),
              Column(
                children: [
                  StepProgressIndicator(
                    totalSteps: 6,
                    currentStep: 2,
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
      },
    );
  }
}
