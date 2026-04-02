import 'package:chat_app/data/model/massage_model.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<UserModel>> getUsers() {
    return firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // this is use for send message to firebase
  Future<void> sendMessage(String chatId, String text, String userId) async {
    await firestore.collection('chats').doc(chatId).collection('messages').add({
      'text': text,
      'senderId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // this is use for get message in real time
  Stream<List<MassageModel>> getMessage(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MassageModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
