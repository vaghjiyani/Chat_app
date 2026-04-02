import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/data/repository/chat_repository.dart';

class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;

  UserLoaded(this.users);
}

class UserError extends UserState {
  final String error;

  UserError(this.error);
}

class UserCubit extends Cubit<UserState> {
  final ChatRepository chatRepository;
  UserCubit(this.chatRepository) : super(UserInitial());

  // this is means there is the a users
  StreamSubscription? _sub;

  void getUsers() {
    _sub?.cancel();
    _sub = chatRepository.getUsers().listen(
      (users) {
        emit(UserLoaded(users));
        print(users);
      },
      onError: (e) {
        emit(UserError(e));
      },
    );
  }
}
