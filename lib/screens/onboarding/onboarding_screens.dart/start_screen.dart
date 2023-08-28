import 'package:dinder/screens/onboarding/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Start extends StatelessWidget {
  final TabController tabController;

  const Start({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              height: 200,
              width: 200,
              child: SvgPicture.asset('assets/logo.svg'),
            ),
            SizedBox(
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
            SizedBox(
              height: 10,
            ),
          ]),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 1,
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
