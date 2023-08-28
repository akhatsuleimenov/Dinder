import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../widgets/widgets.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_header.dart';

class Pictures extends StatelessWidget {
  final TabController tabController;

  const Pictures({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextHeader(text: 'Add 2 Or More Pictures'),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomImageContainer(),
                  CustomImageContainer(),
                  CustomImageContainer(),
                ],
              ),
              Row(
                children: [
                  CustomImageContainer(),
                  CustomImageContainer(),
                  CustomImageContainer(),
                ],
              ),
            ],
          ),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 5,
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
