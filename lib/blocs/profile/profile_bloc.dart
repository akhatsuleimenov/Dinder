import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<EditProfile>(_onEditProfile);
    on<SaveProfile>(_onSaveProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          print('Loading User Profile');
          add(LoadProfile(userId: state.authUser!.uid));
        }
      }
    });
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    print('_onLoadProfile');
    User user = await _databaseRepository.getUser(event.userId).first;
    emit(ProfileLoaded(user: user));
  }

  void _onEditProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) {
    print('_onEditProfile');
    if (state is ProfileLoaded) {
      emit(
        ProfileLoaded(
          user: (state as ProfileLoaded).user,
          isEditingOn: event.isEditingOn,
        ),
      );
    }
  }

  void _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) {
    print('_onSaveProfile');
    if (state is ProfileLoaded) {
      _databaseRepository.updateUser((state as ProfileLoaded).user);
      emit(
        ProfileLoaded(
          user: (state as ProfileLoaded).user,
          isEditingOn: false,
        ),
      );
    }
  }

  void _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) {
    print('_onUpdateUserProfile');
    if (state is ProfileLoaded) {
      emit(
        ProfileLoaded(
          user: event.user,
          isEditingOn: (state as ProfileLoaded).isEditingOn,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
