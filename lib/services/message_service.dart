// lib/services/message_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import 'user_service.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<void> sendMessage(MessageModel message) async {
    // Auto-fetch names if missing
    String senderName = message.senderName;
    String receiverName = message.receiverName;

    if (senderName == 'Unknown User' || senderName.isEmpty) {
      senderName = (await _userService.getUser(message.senderId))['name']!;
    }
    if (receiverName == 'Unknown User' || receiverName.isEmpty) {
      receiverName = (await _userService.getUser(message.receiverId))['name']!;
    }

    final enrichedMessage = MessageModel(
      id: message.id,
      senderId: message.senderId,
      receiverId: message.receiverId,
      senderName: senderName,
      receiverName: receiverName,
      content: message.content,
      timestamp: message.timestamp,
      isRead: message.isRead,
    );

    await _firestore
        .collection('messages')
        .doc(message.id)
        .set(enrichedMessage.toMap());
  }

  Stream<List<MessageModel>> getUserMessages(String userId) {
    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> markAsRead(String messageId) async {
    await _firestore.collection('messages').doc(messageId).update({'isRead': true});
  }
}