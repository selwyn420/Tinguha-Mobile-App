import 'message_model.dart';

class ConversationModel {
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime timestamp;
  final bool isRead;
  final int unreadCount;

  ConversationModel({
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.timestamp,
    required this.isRead,
    required this.unreadCount,
  });

  factory ConversationModel.fromMessages(String currentUserId, List<MessageModel> messages) {
    if (messages.isEmpty) {
      throw Exception('Cannot create conversation from empty messages');
    }

    // Sort to get latest messages first
    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final latestMessage = messages.first;
    
    // Determine other participant's ID
    final otherUserId = latestMessage.senderId == currentUserId 
      ? latestMessage.receiverId 
      : latestMessage.senderId;

    // Determine other participant's name from any message where they're involved
    String otherUserName = 'User';
    for (var msg in messages) {
      if (msg.senderId == otherUserId && msg.senderName != 'You' && msg.senderName.trim().isNotEmpty) {
        otherUserName = msg.senderName;
        break;
      }
      if (msg.receiverId == otherUserId && msg.receiverName != 'You' && msg.receiverName.trim().isNotEmpty) {
        otherUserName = msg.receiverName;
        break;
      }
    }

    // Get the true last message (earliest timestamp among sorted)
    final lastMsg = messages.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
    
    // Build preview: "You: message" if current user sent it, otherwise just the message
    String lastMessageText;
    if (lastMsg.senderId == currentUserId) {
      lastMessageText = 'You: ${lastMsg.content}';
    } else {
      lastMessageText = lastMsg.content; // No prefix needed - other user's name is the title
    }

    // Count unread messages to current user
    final unreadCount = messages.where((msg) => 
      !msg.isRead && msg.receiverId == currentUserId
    ).length;

    return ConversationModel(
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      lastMessage: lastMessageText,
      timestamp: lastMsg.timestamp,
      isRead: unreadCount == 0,
      unreadCount: unreadCount,
    );
  }
}