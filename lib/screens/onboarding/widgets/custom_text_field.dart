import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? initialValue;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(bool)? onFocusChanged;
  final EdgeInsets padding;

  const CustomTextField({
    Key? key,
    this.hint = '',
    this.initialValue = '',
    this.errorText,
    this.onChanged,
    this.onFocusChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Focus(
        onFocusChange: onFocusChanged ?? (hasFocus) {},
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            errorText: errorText,
            hintText: hint,
            contentPadding: const EdgeInsets.only(
              bottom: 5,
              top: 15,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
