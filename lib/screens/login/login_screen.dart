import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/widgets/widgets.dart';
import '/screens/screens.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) {
          return BlocProvider.of<AuthBloc>(context).state.status ==
                  AuthStatus.unauthenticated
              ? const HomeScreen()
              : const LoginScreen();
        });
  }

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "DINDER",
        hasActions: false,
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "Failure to authenticate"),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _EmailInput(),
              const SizedBox(height: 10),
              _PasswordInput(),
              const SizedBox(height: 10),
              const _LoginButton(),
              const SizedBox(
                height: 10,
              ),
              CustomElevatedButton(
                text: 'SIGNUP',
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  OnboardingScreen.routeName,
                  ModalRoute.withName('/onboarding'),
                ),
                beginColor: Theme.of(context).focusColor,
                endColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        return previous.status != current.status;
      },
      builder: (context, state) {
        return state.status == FormzStatus.submissionInProgress
            ? const CircularProgressIndicator()
            : CustomElevatedButton(
                text: 'LOGIN',
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  state.status == FormzStatus.valid
                      ? context.read<LoginCubit>().logInWithCredentials()
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Check your email and password: ${state.status}"),
                          ),
                        );
                },
                beginColor: Colors.white,
                endColor: Colors.white,
              );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText:
                state.email.invalid ? "The email you entered is invalid" : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.invalid
                ? "The password must be at least 8 characters, at least 1 number, at least 1 letter, and no spaces"
                : null,
            errorMaxLines: 2,
          ),
          obscureText: true,
        );
      },
    );
  }
}
