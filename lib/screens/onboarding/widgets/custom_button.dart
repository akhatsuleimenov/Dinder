import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CustomButton extends StatelessWidget {
  final TabController tabController;
  final String text;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const CustomButton({
    super.key,
    required this.tabController,
    this.text = 'START',
    this.emailController,
    this.passwordController,
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
        onPressed: () async {
          if (emailController != null && passwordController != null) {
            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: emailController!.text,
                    password: passwordController!.text)
                .then((value) => logger.i("USER ADDED"))
                .catchError((error) => logger.e("FAILED TO ADD USER",
                    error:
                        error)); // then + catcherror removed loop of validation
          }
          tabController.animateTo(tabController.index + 1);
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
