import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;

  SwipeBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(SwipeLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        logger.i('Auth Subscription: Loading Users');
        add(LoadUsers());
      }
    });
  }

  void _onLoadUsers(
    LoadUsers event,
    Emitter<SwipeState> emit,
  ) {
    logger.i('Loading users');
    if (_authBloc.state.user != null) {
      logger.i('Loading users');
      User currentUser = _authBloc.state.user!;
      logger.i("SUBSCRIPTION BITCH: $_authSubscription");
      _authSubscription?.cancel(); // cancel previous subscription if exists

      logger.i('CURRENTUSER : $currentUser');
      _authSubscription =
          _databaseRepository.getUsersToSwipe(currentUser).listen((users) {
        // if (!_controller.isClosed) {
        add(UpdateHome(users: users));
      });
    }
  }

  void _onUpdateHome(
    UpdateHome event,
    Emitter<SwipeState> emit,
  ) {
    logger.i('Updating Home');
    if (event.users!.isNotEmpty) {
      logger.i('SwipeLoaded');
      emit(SwipeLoaded(users: event.users!));
    } else {
      logger.i('SwipeError');
      emit(SwipeError());
    }
  }

  void _onSwipeLeft(
    SwipeLeft event,
    Emitter<SwipeState> emit,
  ) {
    logger.i("Inside Swipe LEFT");
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;

      List<User> users = List.from(state.users)..remove(event.user);

      _databaseRepository.updateUserSwipe(
        _authBloc.state.authUser!.uid,
        event.user.id!,
        false,
      );

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users));
      } else {
        emit(SwipeError());
      }
    }
  }

  void _onSwipeRight(
    SwipeRight event,
    Emitter<SwipeState> emit,
  ) async {
    logger.i("Inside Swipe Right");
    final state = this.state as SwipeLoaded;
    String userId = _authBloc.state.authUser!.uid;
    List<User> users = List.from(state.users)..remove(event.user);

    _databaseRepository.updateUserSwipe(
      userId,
      event.user.id!,
      true,
    );

    if (event.user.swipeRight!.contains(userId)) {
      await _databaseRepository.updateUserMatch(
        userId,
        event.user.id!,
      );
      logger.i("Updated Swipe Matched");
      emit(SwipeMatched(user: event.user));
    } else if (users.isNotEmpty) {
      logger.i("Updated Swipe Loaded");
      emit(SwipeLoaded(users: users));
    } else {
      logger.i("Updated Swipe Error");
      emit(SwipeError());
    }
  }

  @override
  Future<void> close() async {
    logger.i("INSIDE SWIPEBLOC CANCEL");
    _authSubscription?.cancel();
    super.close();
  }
}
