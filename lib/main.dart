import 'package:chat_app/cubit/auth_cubit.dart';
import 'package:chat_app/cubit/user_cubit.dart';
import 'package:chat_app/data/repository/chat_repository.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final FirebaseServices firebaseServices = FirebaseServices();
    final ChatRepository chat = ChatRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(firebaseServices)),
        BlocProvider(create: (context) => UserCubit(chat)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
