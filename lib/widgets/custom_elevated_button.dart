import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.onPressed,
    required this.color,
    this.width = 300,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final double width;
  final Color color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          fixedSize: Size(width, 40),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
