import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

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
                  authBloc: context.read<AuthBloc>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                )..add(
                    LoadProfile(
                        userId: context.read<AuthBloc>().state.authUser!.uid),
                  ),
                child: const SettingsScreen(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'SETTINGS',
        hasAction: true,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileLoaded) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withAlpha(50),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Set Up your Preferences',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _GenderPreference(),
                    const _AgeRangePreference(),
                  ],
                ),
              );
            } else {
              return const Text("Error");
            }
          },
        ),
      ),
    );
  }
}

class _AgeRangePreference extends StatelessWidget {
  const _AgeRangePreference({
    Key? key,
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
              'Age Range',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Row(
              children: [
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(
                      state.user.ageRangePreference![0].toDouble(),
                      state.user.ageRangePreference![1].toDouble(),
                    ),
                    min: 18,
                    max: 100,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).scaffoldBackgroundColor,
                    onChanged: (rangeValues) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                ageRangePreference: [
                                  rangeValues.start.toInt(),
                                  rangeValues.end.toInt(),
                                ],
                              ),
                            ),
                          );
                    },
                    onChangeEnd: (RangeValues newRangeValues) {
                      print('Ended change on $newRangeValues');
                      context.read<ProfileBloc>().add(
                            SaveProfile(
                              user: state.user.copyWith(
                                ageRangePreference: [
                                  newRangeValues.start.toInt(),
                                  newRangeValues.end.toInt(),
                                ],
                              ),
                            ),
                          );
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${state.user.ageRangePreference![0]} - ${state.user.ageRangePreference![1]}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

class _GenderPreference extends StatelessWidget {
  const _GenderPreference({
    Key? key,
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
              'Show me: ',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Row(
              children: [
                Checkbox(
                  value: state.user.genderPreference!.contains('Male'),
                  onChanged: (value) {
                    if (state.user.genderPreference!.contains('Male')) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..remove('Male'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    } else {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..add('Male'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Man',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: state.user.genderPreference!.contains('Female'),
                  onChanged: (value) {
                    if (state.user.genderPreference!.contains('Female')) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..remove('Female'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    } else {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..add('Female'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Woman',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
