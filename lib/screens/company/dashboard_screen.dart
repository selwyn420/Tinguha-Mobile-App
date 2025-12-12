import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/conversation_model.dart';
import '../../services/message_service.dart';
import '../welcome_screen.dart';
import 'profile_screen.dart';
import 'post_job_screen.dart';
import 'company_job_postings_screen.dart';
import 'company_candidates_screen.dart';
import '../message_detail_screen.dart';
import '../new_message_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final TextEditingController _personSearchController = TextEditingController();
  final TextEditingController _messageSearchController = TextEditingController();
  final MessageService _messageService = MessageService();
  
  // Get current user ID from Firebase Auth
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  // Check if user is authenticated
  bool get isAuthenticated => currentUserId != null;

  @override
  Widget build(BuildContext context) {
    // Show loading if checking auth
    if (!isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking authentication...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WELCOME'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _showLogoutConfirmation,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_currentIndex == 0) _buildSearchBar(_personSearchController, 'Search for candidates...'),
          if (_currentIndex == 1) _buildSearchBar(_messageSearchController, 'Search messages...'),
          Expanded(child: _buildCurrentPage()),
          if (_currentIndex == 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PostJobScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 4,
                  ),
                  child: const Text(
                    'POST JOB',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Company'),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0: return _buildHomePage();
      case 1: return _buildMessagesPage();
      case 2: return _buildAnalyticsPage();
      case 3: return const ProfileScreen();
      default: return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildActionCard(
                    icon: Icons.work,
                    title: 'Active Job Posting',
                    subtitle: 'Manage and view your job postings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyJobPostingsScreen(companyId: currentUserId!),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  flex: 1,
                  child: _buildActionCard(
                    icon: Icons.people,
                    title: 'View Candidates',
                    subtitle: 'Browse and manage job applicants',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyCandidatesScreen(companyId: currentUserId!),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(onTap: onTap, child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF2563EB)),
            const SizedBox(width: 16.0),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
              Text(subtitle, style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
            ])),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
          ],
        ),
      )),
    );
  }

  Widget _buildMessagesPage() {
    return Scaffold(
      body: StreamBuilder<List<ConversationModel>>(
        stream: _messageService.getConversations(currentUserId!),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final conversations = snapshot.data ?? [];
          
          if (conversations.isEmpty) {
            return _buildEmptyState(Icons.message_outlined, 'No messages yet', 'Tap + to start a conversation');
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: conversations.length,
            itemBuilder: (context, index) => _buildConversationCard(conversations[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewMessageScreen(currentUserId: currentUserId!),
            ),
          );
        },
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildConversationCard(ConversationModel conversation) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 12.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailScreen(
              otherUserId: conversation.otherUserId,
              otherUserName: conversation.otherUserName,
              currentUserId: currentUserId!,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar with other person's initial
            CircleAvatar(
              backgroundColor: const Color(0xFF2563EB),
              radius: 24,
              child: Text(
                conversation.otherUserName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            
            // Message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.otherUserName,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: conversation.isRead ? FontWeight.w600 : FontWeight.bold,
                      color: conversation.isRead ? Colors.grey[800] : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    conversation.lastMessage,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: conversation.isRead ? FontWeight.normal : FontWeight.w500,
                      color: conversation.isRead ? Colors.grey[600] : Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Timestamp and unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _formatTimestamp(conversation.timestamp),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: conversation.isRead ? FontWeight.normal : FontWeight.bold,
                    color: conversation.isRead ? Colors.grey[500] : const Color(0xFF2563EB),
                  ),
                ),
                if (conversation.unreadCount > 0) ...[
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(minWidth: 24),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildAnalyticsPage() {
    return const Center(child: Text('Analytics', style: TextStyle(fontSize: 24.0)));
  }

  Widget _buildCompanyPage() {
    return const ProfileScreen();
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 64, color: Colors.grey[400]),
      const SizedBox(height: 16.0),
      Text(title, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
      Text(subtitle, style: const TextStyle(fontSize: 14.0, color: Colors.grey)),
    ]));
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'now';
  }

  void _showLogoutConfirmation() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Row(children: [Icon(Icons.logout, color: Colors.blueAccent), SizedBox(width: 8), Text('Logout')]),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
          child: const Text('Logout'),
        ),
      ],
    ));
  }

  // Updated logout method that actually signs out from Firebase
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    _personSearchController.dispose();
    _messageSearchController.dispose();
    super.dispose();
  }
}