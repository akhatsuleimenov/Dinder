import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../widgets/widgets.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_text_header.dart';

class Bio extends StatelessWidget {
  final TabController tabController;

  const Bio({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextHeader(text: 'Tell Me Who R U?'),
            CustomTextField(
              hint: 'BIO HERE',
              controller: controller,
            ),
            const SizedBox(
              height: 100,
            ),
            CustomTextHeader(text: 'What Do You Like?'),
            Row(
              children: [
                CustomTextContainer(text: 'Music'),
                CustomTextContainer(text: 'Art'),
                CustomTextContainer(text: 'Sports'),
                CustomTextContainer(text: 'Chess'),
              ],
            ),
          ]),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 6,
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
