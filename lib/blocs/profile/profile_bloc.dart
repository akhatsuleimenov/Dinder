import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/widgets.dart';
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
          logger.i('Loading User Profile');
          add(LoadProfile(userId: state.authUser!.uid));
        }
      }
    });
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    logger.i('_onLoadProfile');
    User user = await _databaseRepository.getUser(event.userId!).first;
    emit(ProfileLoaded(user: user));
  }

  void _onEditProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) {
    logger.i('_onEditProfile');
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
    logger.i('_onSaveProfile');
    if (state is ProfileLoaded) {
      logger.i("PASSING THIS USER: ${(state as ProfileLoaded).user}");
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
    logger.i('_onUpdateUserProfile');
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
    logger.i("INSIDE PROFILEBLOC CANCEL");
    _authSubscription?.cancel();
    super.close();
  }
}
