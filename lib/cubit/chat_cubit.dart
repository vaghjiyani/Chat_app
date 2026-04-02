import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/model/massage_model.dart';
import 'package:chat_app/data/repository/chat_repository.dart';

class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MassageModel> messages;

  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  ChatCubit(this.chatRepository) : super(ChatInitial());

  StreamSubscription? _chat;

  // this is for to get the msg
  void getMessage(String chatId) {
    _chat?.cancel();

    _chat = chatRepository
        .getMessage(chatId)
        .listen(
          (event) {
            emit(ChatLoaded(event));
          },
          onError: (e) {
            emit(ChatError(e));
          },
        );
  }

  void sendMessage(String chatID, String text, String userId) {
    chatRepository.sendMessage(chatID, text, userId);
  }
}
