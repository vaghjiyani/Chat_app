import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String uid;
  final DateTime createdAt;

  UserModel({required this.uid, required this.createdAt, required this.name});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['userId'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
