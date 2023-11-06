import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';

import '/widgets/widgets.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _chatSubscription;

  ChatBloc({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(ChatLoading()) {
    on<LoadChat>(_onLoadChat);
    on<UpdateChat>(_onUpdateChat);
    on<AddMessage>(_onAddMessage);
    on<DeleteChat>(_onDeleteChat);
  }

  void _onLoadChat(
    LoadChat event,
    Emitter<ChatState> emit,
  ) {
    _chatSubscription =
        _databaseRepository.getChat(event.chatId!).listen((chat) {
      add(UpdateChat(chat: chat));
    });
  }

  void _onAddMessage(
    AddMessage event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatLoaded) {
      final state = this.state as ChatLoaded;

      final Message message = Message(
        senderId: event.userId,
        receiverId: event.matchUserId,
        message: event.message,
        dateTime: DateTime.now(),
        timeString: DateFormat("HH:mm").format(DateTime.now()),
      );

      _databaseRepository.addMessage(state.chat.id, message);
      emit(ChatLoaded(chat: state.chat));
    }
  }

  void _onUpdateChat(
    UpdateChat event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatLoaded(chat: event.chat));
  }

  void _onDeleteChat(
    DeleteChat event,
    Emitter<ChatState> emit,
  ) {
    _chatSubscription?.cancel();

    if (state is ChatLoaded) {
      final state = this.state as ChatLoaded;

      _databaseRepository.deleteMatch(
        state.chat.id,
        event.userId,
        event.matchUserId,
      );

      emit(const ChatDeleted());
    }
  }

  @override
  Future<void> close() {
    logger.i("INSIDE CHATBLOC CANCEL");
    _chatSubscription?.cancel();
    return super.close();
  }
}
