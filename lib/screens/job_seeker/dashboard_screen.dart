import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../models/application_model.dart';
import '../../services/job_service.dart';
import '../../services/message_service.dart';
import '../../services/application_service.dart';
import '../job_detail_screen.dart';
import '../message_detail_screen.dart';
import '../welcome_screen.dart';
import 'profile_screen.dart';
import '../new_message_screen.dart';
import '../../models/conversation_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final TextEditingController _jobSearchController = TextEditingController();
  final TextEditingController _messageSearchController = TextEditingController();
  final MessageService _messageService = MessageService();
  final ApplicationService _applicationService = ApplicationService();
  
  // Get current user ID from Firebase Auth
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  // Check if user is authenticated
  bool get isAuthenticated => currentUserId != null;

  @override
  Widget build(BuildContext context) {
    // Show loading screen if not authenticated
    if (!isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Checking authentication...'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WELCOME'),
        backgroundColor: Colors.blueAccent,
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
          if (_currentIndex == 0) _buildSearchBar(_jobSearchController, 'Search for jobs...'),
          if (_currentIndex == 1) _buildSearchBar(_messageSearchController, 'Search messages...'),
          Expanded(child: _buildCurrentPage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildSearchBar(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 50.0,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0: return _buildHomePage();
      case 1: return _buildMessagesPage();
      case 2: return _buildApplicationsPage();
      case 3: return const ProfileScreen();
      default: return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    final jobService = JobService();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('RECOMMENDED', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
          const SizedBox(height: 16.0),
          Expanded(
            child: StreamBuilder<List<JobModel>>(
              stream: jobService.getActiveJobs(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final jobs = snapshot.data ?? [];
                
                if (jobs.isEmpty) {
                  return _buildEmptyState(Icons.work_outline, 'No jobs available yet', 'Check back later for new opportunities');
                }
                
                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) => _buildJobCard(jobs[index]),
                );
              },
            ),
          ),
        ],
      ),
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
      backgroundColor: Colors.blueAccent,
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
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
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
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTimestamp(conversation.timestamp),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: conversation.isRead ? FontWeight.normal : FontWeight.bold,
                    color: conversation.isRead ? Colors.grey[500] : Colors.blueAccent,
                  ),
                ),
                if (conversation.unreadCount > 0) ...[
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
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

String _formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);
  
  if (difference.inDays > 0) return '${difference.inDays}d';
  if (difference.inHours > 0) return '${difference.inHours}h';
  if (difference.inMinutes > 0) return '${difference.inMinutes}m';
  return 'now';
}

  Widget _buildApplicationsPage() {
    return StreamBuilder<List<ApplicationModel>>(
      stream: _applicationService.getUserApplications(currentUserId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final applications = snapshot.data ?? [];
        
        if (applications.isEmpty) {
          return _buildEmptyState(
            Icons.work_outline,
            'No applications yet',
            'Apply for jobs to see them here',
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: applications.length,
          itemBuilder: (context, index) => _buildApplicationCard(applications[index]),
        );
      },
    );
  }

  Widget _buildApplicationCard(ApplicationModel application) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              application.jobTitle ?? 'Unknown Job',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              application.companyName ?? 'Unknown Company',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(application.status),
                Text(
                  _formatTimestamp(application.appliedDate),
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;
    
    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        statusText = 'Pending';
        break;
      case 'accepted':
        chipColor = Colors.green;
        statusText = 'Accepted';
        break;
      case 'rejected':
        chipColor = Colors.red;
        statusText = 'Rejected';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Unknown';
    }
    
    return Chip(
      label: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

Widget _buildJobCard(JobModel job) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(
                job: job,
                currentUserId: currentUserId!,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.jobTitle,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                job.companyName,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4.0),
                  Text(job.location, style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
                  const SizedBox(width: 16.0),
                  Icon(Icons.work, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4.0),
                  Text(job.employmentType, style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                job.jobDescription,
                style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16.0),
          Text(title, style: const TextStyle(fontSize: 16.0, color: Colors.grey)),
          const SizedBox(height: 8.0),
          Text(subtitle, style: const TextStyle(fontSize: 14.0, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

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
    _jobSearchController.dispose();
    _messageSearchController.dispose();
    super.dispose();
  }
}