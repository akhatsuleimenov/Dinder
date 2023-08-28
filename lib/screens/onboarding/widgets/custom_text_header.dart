import 'package:flutter/material.dart';

class CustomTextHeader extends StatelessWidget {
  final String text;
  const CustomTextHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .displayLarge
          ?.copyWith(fontWeight: FontWeight.normal),
    );
  }
}
