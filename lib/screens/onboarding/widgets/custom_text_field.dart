import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.initialValue = '',
    this.errorText,
    this.onChanged,
    this.hint = '',
    this.padding = const EdgeInsets.symmetric(horizontal: 5),
    required this.keyboardType,
    this.inputFormat,
    required this.maxLength,
  }) : super(key: key);

  final String? initialValue;
  final String? errorText;
  final Function(String)? onChanged;
  final String? hint;
  final EdgeInsets padding;
  final TextInputType keyboardType;
  final TextInputFormatter? inputFormat;
  final int maxLength;

  @override
  ParentWidgetState createState() => ParentWidgetState();
}

class ParentWidgetState extends State<CustomTextField> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final actualInputFormat = widget.inputFormat ??
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'));
    return Padding(
      padding: widget.padding,
      child: Focus(
        child: TextField(
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          inputFormatters: [actualInputFormat],
          controller: controller,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: widget.initialValue,
            filled: true,
            hintText: widget.hint,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            errorText: widget.errorText,
            contentPadding: const EdgeInsets.only(
              bottom: 5,
              top: 15,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
            //   borderRadius: BorderRadius.circular(10),
            // ),
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
