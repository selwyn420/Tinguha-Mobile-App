import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all messages between two users (full conversation)
  Stream<List<MessageModel>> getConversationMessages(String userId1, String userId2) {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
              .where((msg) =>
                  (msg.senderId == userId1 && msg.receiverId == userId2) ||
                  (msg.senderId == userId2 && msg.receiverId == userId1))
              .toList();
          
          return messages;
        });
  }

  // Get all conversations for a user (grouped by other user)
  Stream<List<ConversationModel>> getConversations(String currentUserId) {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      // Filter messages where user is either sender or receiver
      final allMessages = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
          .where((msg) => 
              msg.senderId == currentUserId || msg.receiverId == currentUserId)
          .toList();

      if (allMessages.isEmpty) return [];

      // Group messages by other user
      final Map<String, List<MessageModel>> groupedMessages = {};
      for (var message in allMessages) {
        final otherUserId = message.senderId == currentUserId
            ? message.receiverId
            : message.senderId;
        
        if (!groupedMessages.containsKey(otherUserId)) {
          groupedMessages[otherUserId] = [];
        }
        groupedMessages[otherUserId]!.add(message);
      }

      // Convert to ConversationModel list
      final conversations = groupedMessages.entries
          .map((entry) => ConversationModel.fromMessages(currentUserId, entry.value))
          .toList();

      // Sort by latest message timestamp
      conversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return conversations;
    });
  }

  // Send a message
  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection('messages').add(message.toMap());
  }

  // Mark a message as read
  Future<void> markAsRead(String messageId) async {
    await _firestore.collection('messages').doc(messageId).update({'isRead': true});
  }

  // Get unread message count for a user
  Future<int> getUnreadCount(String userId) async {
    final snapshot = await _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    
    return snapshot.docs.length;
  }

  // Legacy method for backward compatibility (if needed)
  Stream<List<MessageModel>> getUserMessages(String userId) {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
              .where((msg) => msg.senderId == userId || msg.receiverId == userId)
              .toList();
        });
  }
}