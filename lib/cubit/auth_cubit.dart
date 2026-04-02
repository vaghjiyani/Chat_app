import 'package:bloc/bloc.dart';
import 'package:chat_app/services/firebase_services.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final FirebaseServices firebaseServices;
  AuthCubit(this.firebaseServices) : super(AuthInitial()) {
    check();
  }

  void check() {
    final user = firebaseServices.currentUser;
    if (user != null) {
      emit(AuthSuccess());
    } else {
      emit(AuthError("error"));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await firebaseServices.register(email, password, name);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await firebaseServices.login(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await firebaseServices.logout();
    emit(AuthInitial());
  }
}
