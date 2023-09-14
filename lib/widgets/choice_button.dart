import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final double width;
  final double height;
  final double size;
  final bool hasGradient;
  final Color color;
  final IconData icon;

  const ChoiceButton(
      {super.key,
      this.width = 60,
      this.height = 60,
      this.size = 25,
      this.hasGradient = false,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          gradient: hasGradient
              ? LinearGradient(
                  colors: [
                    Theme.of(context).focusColor,
                    Theme.of(context).primaryColor,
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 4,
                blurRadius: 4,
                offset: const Offset(3, 3))
          ]),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
