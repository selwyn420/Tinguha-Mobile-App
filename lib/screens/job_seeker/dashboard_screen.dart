import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'package:finals/screens/welcome_screen.dart'; 


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final TextEditingController _jobSearchController = TextEditingController();
  final TextEditingController _messageSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WELCOME'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
        actions: [
          // Logout Button
          IconButton(
            onPressed: _showLogoutConfirmation,
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar - Show job search in Home tab (index 0)
          if (_currentIndex == 0) 
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50.0,
                child: TextField(
                  controller: _jobSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search for jobs...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
              ),
            ),
          
          // Search Bar - Show message search in Messages tab (index 1)
          if (_currentIndex == 1) 
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 50.0,
                child: TextField(
                  controller: _messageSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search messages...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
              ),
            ),
          
          // Page Content
          Expanded(
            child: _buildCurrentPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // Navigate back to welcome screen and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0: // Home
        return _buildHomePage();
      case 1: // Messages
        return _buildMessagesPage();
      case 2: // Applications
        return _buildApplicationsPage();
      case 3: // Profile
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RECOMMENDED Section Header
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'RECOMMENDED',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          
          // Empty State
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'No recommended jobs yet',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Complete your profile to get job recommendations',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Messages content will go here below the search bar
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Your conversations will appear here',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.0),
          Text(
            'Applications Page',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Your job applications will appear here',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return ProfileScreen();
  }

  @override
  void dispose() {
    _jobSearchController.dispose();
    _messageSearchController.dispose();
    super.dispose();
  }
}