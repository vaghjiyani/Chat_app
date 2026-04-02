import 'package:chat_app/cubit/auth_cubit.dart';
import 'package:chat_app/cubit/chat_cubit.dart';
import 'package:chat_app/cubit/user_cubit.dart';
import 'package:chat_app/data/repository/chat_repository.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreens extends StatefulWidget {
  const UsersScreens({super.key});

  @override
  State<UsersScreens> createState() => _UsersScreensState();
}

class _UsersScreensState extends State<UsersScreens> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is UserLoaded) {
            final user = state.users;

            return ListView.builder(
              itemCount: user.length,

              itemBuilder: (context, index) {
                final userData = user[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(userData.name),

                    onTap: () {
                      final currentUid = FirebaseAuth.instance.currentUser!.uid;
                      final otherUid = userData.uid;
                      final ids = [currentUid, otherUid]..sort();
                      final chatId = ids.join('_');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => ChatCubit(ChatRepository()),
                            child: ChatScreen(
                              userId: currentUid,
                              chatId: chatId,
                            ),
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(radius: 20.0, child: Text("$index")),
                  ),
                );
              },
            );
          }
          if (state is UserError) {
            return Center(child: Text(state.error));
          }

          return Center(child: Text('No users found'));
        },
      ),
    );
  }
}
