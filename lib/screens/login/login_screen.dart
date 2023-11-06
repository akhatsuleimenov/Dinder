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
                AuthStatus.authenticated
            ? const HomeScreen()
            : const LoginScreen();
      },
    );
  }

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        return previous.status != current.status;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: "DINDER",
          ),
          body: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status.isSubmissionFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(state.errorMessage ?? "Failure to authenticate"),
                  ),
                );
              }
            },
            child: state.status == FormzStatus.submissionInProgress ||
                    state.status == FormzStatus.submissionSuccess
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _EmailInput(),
                        const SizedBox(height: 10),
                        _PasswordInput(),
                        const SizedBox(height: 10),
                        _LogInButton(state: state),
                        const SizedBox(height: 10),
                        const _SignUpButton(),
                        // const Divider(
                        //   thickness: 2,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     _ThirdPartySignIn(
                        //       imagePath: 'assets/google.png',
                        //       onTap: () async {
                        //         print("Pressed");
                        //         // User? user =
                        //             // await context.read<SignupCubit>().signInWithGoogle();
                        //         // User? user = await AuthService.signInWithGoogle();
                        //         // print(user);
                        //         // if (user != null) {
                        //         //   print(user.email);
                        //           Navigator.of(context).pushReplacementNamed(
                        //               OnboardingScreen.routeName);
                        //         // }
                        //       },
                        //     ),
                        //     const SizedBox(width: 25),
                        //     _ThirdPartySignIn(
                        //       imagePath: 'assets/apple.png',
                        //       onTap: () {},
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      color: Theme.of(context).primaryColor,
      text: 'SIGN UP',
      textColor: Colors.white,

      // onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
      //     OnboardingScreen.routeName, ModalRoute.withName('/onboarding')),
      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
          OnboardingScreen.routeName, (route) => false),
    );
  }
}

// class _ThirdPartySignIn extends StatelessWidget {
//   final String imagePath;
//   final Function()? onTap;
//   const _ThirdPartySignIn({
//     required this.imagePath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.white),
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.grey[200],
//         ),
//         child: Image.asset(
//           imagePath,
//           height: 40,
//         ),
//       ),
//     );
//   }
// }

class _LogInButton extends StatelessWidget {
  final LoginState state;

  const _LogInButton({required this.state});

  @override
  Widget build(BuildContext context) {
    logger.i("STATUS: ${state.status}");
    return state.status == FormzStatus.submissionInProgress
        ? const CircularProgressIndicator()
        : CustomElevatedButton(
            text: 'LOG IN',
            color: Colors.white,
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              if (state.status == FormzStatus.valid) {
                logger.i("STATUS 2: ${state.status}");
                context.read<LoginCubit>().logInWithCredentials();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName, (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your email or password is incorrect!"),
                  ),
                );
              }
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
            hintText: "@nyu.edu",
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
          decoration: const InputDecoration(
            labelText: 'Password',
            // errorText: state.password.invalid
            //     ? "The password must be at least 8 characters, at least 1 number, at least 1 letter, and no spaces"
            //     : null,
            // errorMaxLines: 2,
          ),
          obscureText: true,
        );
      },
    );
  }
}
