import 'package:cloud_firestore/cloud_firestore.dart';

class MassageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  MassageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory MassageModel.fromMap(Map<String, dynamic> map) {
    return MassageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
