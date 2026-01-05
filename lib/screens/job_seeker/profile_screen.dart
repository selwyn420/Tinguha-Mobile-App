import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_service.dart';
import '../welcome_screen.dart';
import 'edit_profile_screen.dart';
import 'profile_preview_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _userService.getJobSeekerProfile(userId);
    setState(() => _profileData = profile);
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profileData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final personalInfo = _profileData!['personal_info'] ?? {};
    final educationalBackground = _profileData!['educational_background'] ?? {};

    return Scaffold(
      // Keep your original structure
      body: Column(
        children: [
          // Profile Picture Section
          Container(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.add_a_photo, size: 18, color: Colors.white),
                          onPressed: () => _showAddPhotoOptions(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  'Add Profile Picture',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.blueAccent),
                ),
              ],
            ),
          ),

          // View My Profile Button - NOW WORKS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () => _showProfilePreview(personalInfo, educationalBackground),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  elevation: 1,
                  side: BorderSide(color: Colors.blueAccent, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility, size: 20),
                    SizedBox(width: 8.0),
                    Text('View My Profile', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),

          // Profile Information with REAL DATA
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Applicant Information
                _buildInfoCard('Applicant Information', [
                  _buildInfoRow('Name', '${personalInfo['first_name'] ?? 'Not provided'} ${personalInfo['last_name'] ?? ''}'.trim()),
                  _buildInfoRow('Address', personalInfo['permanent_address'] ?? 'Not provided'),
                ]),

                SizedBox(height: 16.0),

                // Contact Information
                _buildInfoCard('Contact Information', [
                  _buildInfoRow('Email', FirebaseAuth.instance.currentUser?.email ?? 'Not provided'),
                  _buildInfoRow('Phone Number', personalInfo['phone_number'] ?? 'Not provided'),
                ]),

                SizedBox(height: 16.0),

                // Edit Profile Button - NOW WORKS
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () => _navigateToEdit(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text('Edit Profile', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> rows) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            SizedBox(height: 16.0),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value.isNotEmpty ? value : 'Not provided')),
        ],
      ),
    );
  }

  void _showAddPhotoOptions() {
    // Keep your original implementation
  }

  void _showProfilePreview(Map<String, dynamic> personalInfo, Map<String, dynamic> educationalBackground) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProfilePreviewScreen(
        personalInfo: personalInfo,
        educationalBackground: educationalBackground,
      ),
    );
  }

  void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profileData: _profileData!),
      ),
    ).then((_) => _loadProfile()); // Reload after editing
  }
}