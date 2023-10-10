import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../onboarding/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) {
          print(BlocProvider.of<AuthBloc>(context).state);

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
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Text(
                            state.user.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomElevatedButton(
                      text: state.isEditingOn ? 'Save' : 'Edit',
                      beginColor: state.isEditingOn
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      endColor: state.isEditingOn
                          ? Colors.white
                          : Theme.of(context).scaffoldBackgroundColor,
                      textColor: state.isEditingOn
                          ? Colors.white
                          : Theme.of(context).primaryColor,
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
                          onChanged: (value) {
                            if (value == null || value == '') {
                              return;
                            }
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user
                                        .copyWith(age: int.parse(value)),
                                  ),
                                );
                          },
                        ),
                        _TextField(
                          title: 'Major',
                          value: state.user.major,
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

  const _TextField({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
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
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            state.isEditingOn
                ? CustomTextField(
                    initialValue: value,
                    onChanged: onChanged,
                  )
                : Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(height: 1.5),
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                RepositoryProvider.of<AuthRepository>(context).signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              child: Center(
                child: Text(
                  'Sign Out',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
