import 'package:flutter/material.dart';

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
        onPressed: () {
          tabController.animateTo(tabController.index + 1);
        },
        child: Container(
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
