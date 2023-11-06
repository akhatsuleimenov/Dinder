import 'package:dinder/cubits/login/login_cubit.dart';
import 'package:dinder/screens/onboarding/widgets/custom_text_field.dart';
import 'package:dinder/services/index_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';

bool isNumeric(String s) {
  return RegExp(r'^[0-9]+$').hasMatch(s);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) {
          logger.i(BlocProvider.of<AuthBloc>(context).state);

          return BlocProvider.of<AuthBloc>(context).state.status ==
                  AuthStatus.unauthenticated
              ? const LoginScreen()
              : BlocProvider<ProfileBloc>(
                  create: (context) => ProfileBloc(
                      authBloc: BlocProvider.of<AuthBloc>(context),
                      databaseRepository: context.read<DatabaseRepository>())
                    ..add(
                      LoadProfile(
                          userId: context.read<AuthBloc>().state.authUser!.uid),
                    ),
                  child: const ProfileScreen(),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'PROFILE',
        hasAction: true,
      ),
      bottomNavigationBar: const CustomBottomBar(),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  UserImage.medium(
                    url: state.user.imageUrls[0],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.9),
                            Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            state.user.name,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomElevatedButton(
                      text: state.isEditingOn ? 'Save' : 'Edit',
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                              state.isEditingOn
                                  ? SaveProfile(user: state.user)
                                  : const EditProfile(isEditingOn: true),
                            );
                      },
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TextField(
                          title: 'Biography',
                          value: state.user.bio,
                          inputFormat: FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9 ]')),
                          maxLength: 100,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(bio: value),
                                  ),
                                );
                          },
                        ),
                        _TextField(
                          title: 'Age',
                          value: '${state.user.age}',
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          inputFormat: FilteringTextInputFormatter.digitsOnly,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user
                                        .copyWith(age: int.parse(value!)),
                                  ),
                                );
                          },
                        ),
                        _TextField(
                          title: 'Major',
                          value: state.user.major,
                          keyboardType: TextInputType.text,
                          maxLength: 30,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(major: value),
                                  ),
                                );
                          },
                        ),
                        const _Pictures(),
                        // const _Interests(),
                        const _SignOut(),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const Text("error");
            }
          },
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String title;
  final String value;
  final Function(String?) onChanged;
  final TextInputType keyboardType;
  final TextInputFormatter? inputFormat;
  final int maxLength;

  const _TextField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.keyboardType,
    required this.maxLength,
    this.inputFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 10),
            state.isEditingOn
                ? CustomTextField(
                    initialValue: value,
                    onChanged: onChanged,
                    keyboardType: keyboardType,
                    inputFormat: inputFormat,
                    maxLength: maxLength,
                  )
                : Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

// class _Interests extends StatelessWidget {
//   const _Interests({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileBloc, ProfileState>(
//       builder: (context, state) {
//         state as ProfileLoaded;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Interests',
//               style: Theme.of(context).textTheme.displaySmall,
//             ),
//             Row(
//               children: [
//                 CustomTextContainer(text: state.user.interests[0]),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class _Pictures extends StatelessWidget {
  const _Pictures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pictures',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: state.user.imageUrls.isNotEmpty ? 125 : 0,
              child: ListView.builder(
                itemCount: state.user.imageUrls.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: UserImage.small(
                      width: 100,
                      url: state.user.imageUrls[index],
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Center(
          child: CustomElevatedButton(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            text: 'Sign Out',
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              IndexService.instance.logout();
              RepositoryProvider.of<AuthRepository>(context).signOut();
              context.read<LoginCubit>().statusChanged(FormzStatus.pure);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (route) => false);
            },
          ),
        );
      },
    );
  }
}
