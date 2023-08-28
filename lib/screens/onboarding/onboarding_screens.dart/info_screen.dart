import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_text_header.dart';

class Info extends StatelessWidget {
  final TabController tabController;

  const Info({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextHeader(text: 'What\'s Your Gender?'),
            const SizedBox(
              height: 10,
            ),
            CustomCheckBox(text: 'MALE'),
            CustomCheckBox(text: 'FEMALE'),
            const SizedBox(
              height: 100,
            ),
            CustomTextHeader(text: 'What\'s Your Age?'),
            CustomTextField(text: 'ENTER YOUR AGE'),
          ]),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 4,
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
  }
}
