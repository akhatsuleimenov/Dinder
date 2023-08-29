import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_text_header.dart';

class Email extends StatelessWidget {
  final TabController tabController;

  const Email({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextHeader(text: 'What\'s your email address?'),
            CustomTextField(
                hint: 'ENTER YOUR EMAIL', controller: emailController),
            SizedBox(height: 100),
            CustomTextHeader(text: 'Choose a Password'),
            CustomTextField(
                hint: 'ENTER YOUR PASSWORD', controller: passwordController),
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
                emailController: emailController,
                passwordController: passwordController,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
