import 'package:dinder/cubits/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
    var logger = Logger();
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
          if (tabController.index == 2) {
            context.read<SignupCubit>().signupWithCredentials();
            logger.i("signuped");
          }
        },
        child: SizedBox(
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
