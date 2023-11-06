import 'package:animated_toggle_switch/animated_toggle_switch.dart';
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
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GenderPreference(),
                    _AgeRangePreference(),
                    Center(child: _GiverPreference()),
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

class _GiverPreference extends StatelessWidget {
  const _GiverPreference();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giver or Getter today?',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedToggleSwitch.dual(
                  onChanged: (bool value) {
                    context.read<ProfileBloc>().add(
                          UpdateUserProfile(
                              user: state.user.copyWith(giver: value)),
                        );
                    context
                        .read<ProfileBloc>()
                        .add(SaveProfile(user: state.user));
                  },
                  current: state.user.giver,
                  first: true,
                  second: false,
                  iconBuilder: (value) => value
                      ? const Icon(Icons.fastfood)
                      : const Icon(Icons.no_food),
                  textBuilder: (value) => value
                      ? Center(
                          child: Text(
                          'GIVE',
                          style: Theme.of(context).textTheme.displaySmall,
                        ))
                      : Center(
                          child: Text(
                            'GET',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                  style: ToggleStyle(
                    indicatorColor: Theme.of(context).primaryColor,
                    backgroundGradient: LinearGradient(
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).primaryColor,
                      ],
                    ),
                    borderColor: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withAlpha(50),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
              'Age Range: ',
              style: Theme.of(context).textTheme.displayMedium,
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
                    max: 99,
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
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 13),
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
            Text('Show me: ', style: Theme.of(context).textTheme.displayMedium),
            _SexPicker(gender: 'Male', state: state),
            _SexPicker(gender: 'Female', state: state),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

class _SexPicker extends StatelessWidget {
  final String gender;
  final ProfileLoaded state;

  const _SexPicker({
    required this.gender,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: state.user.genderPreference!.contains(gender),
          onChanged: (value) {
            List<String> updatedPreference;
            if (state.user.genderPreference!.contains(gender)) {
              updatedPreference = List.from(state.user.genderPreference!)
                ..remove(gender);
            } else {
              updatedPreference = List.from(state.user.genderPreference!)
                ..add(gender);
            }
            context.read<ProfileBloc>().add(
                  UpdateUserProfile(
                    user: state.user
                        .copyWith(genderPreference: updatedPreference),
                  ),
                );
            context.read<ProfileBloc>().add(
                  SaveProfile(user: state.user),
                );
          },
          visualDensity: VisualDensity.compact,
        ),
        Text(
          gender,
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
