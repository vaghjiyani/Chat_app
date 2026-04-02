import 'package:chat_app/cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String chatId;
  const ChatScreen({super.key, required this.userId, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getMessage(widget.chatId);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // this is use for whne click on textfield then keyboard will not hide
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Home'), centerTitle: true),

      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoaded) {
            final msg = state.messages;
            final currentUserId = FirebaseAuth
                .instance
                .currentUser!
                .uid; //for getting currentUserId from auth
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: msg.length,
                    itemBuilder: (context, index) {
                      final msgUser = msg[index];
                      final me =
                          msgUser.senderId ==
                          currentUserId; // compare senderId and currentUserId
                      return Align(
                        alignment: me
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: me ? Colors.blue : Colors.green,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: me
                                  ? Radius.circular(20)
                                  : Radius.circular(0),
                              bottomRight: me
                                  ? Radius.circular(0)
                                  : Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(msgUser.text),
                              SizedBox(),
                              Text(
                                TimeOfDay.fromDateTime(
                                  msgUser.timestamp,
                                ).format(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<ChatCubit>().sendMessage(
                            widget.chatId,
                            controller.text,
                            widget.userId,
                          );
                          controller.clear();
                        },
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (state is ChatError) {
            return Text(state.message);
          }
          return Center(child: Text("this is empty"));
        },
      ),
    );
  }
}
