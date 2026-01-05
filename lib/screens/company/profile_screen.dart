import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/user_service.dart';
import '../welcome_screen.dart';
import 'edit_profile_screen.dart';
import 'profile_preview_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _CompanyProfileScreenState createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _userService.getCompanyProfile(userId);
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          // Company Logo Section
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
                      child: Icon(Icons.business, size: 60, color: Colors.grey[600]),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.add_a_photo, size: 18, color: Colors.white),
                          onPressed: () {
                            // TODO: Implement photo picker
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Logo upload - Coming soon!')),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  'Add Company Logo',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),

          // View Company Profile Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () => _showCompanyProfilePreview(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  elevation: 1,
                  side: BorderSide(color: Colors.blueAccent, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility, size: 20),
                    SizedBox(width: 8.0),
                    Text(
                      'View Company Profile',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),

          // Company Information with REAL DATA
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company Information',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        SizedBox(height: 16.0),
                        _buildInfoRow('Company Name:', _profileData!['company_name'] ?? 'Not provided'),
                        _buildInfoRow('Industry:', _profileData!['industry'] ?? 'Not provided'),
                        _buildInfoRow('Company Size:', _profileData!['company_size'] ?? 'Not provided'),
                        _buildInfoRow('Location:', _profileData!['address'] ?? 'Not provided'),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // Contact Information
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Information',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        SizedBox(height: 16.0),
                        _buildInfoRow('Email:', FirebaseAuth.instance.currentUser?.email ?? 'Not provided'),
                        _buildInfoRow('Phone Number:', _profileData!['phone_number'] ?? 'Not provided'),
                        _buildInfoRow('Website:', _profileData!['website'] ?? 'Not provided'),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // About Company
                if (_profileData!['about_company'] != null)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Company',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            _profileData!['about_company'],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),

                // Documents
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Documents',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        SizedBox(height: 16.0),
                        _buildDocumentRow('Certificate of Registration:', _profileData!['certificate_file_name']),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () => _editCompanyProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: Text('Edit Company Profile', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 16.0),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Logout', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ),
          Expanded(
            child: Text(value.isNotEmpty ? value : 'Not provided'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String label, String? fileName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ),
          if (fileName != null && fileName.isNotEmpty)
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.insert_drive_file, size: 16, color: Colors.blueAccent),
                label: Text('View Document', style: TextStyle(color: Colors.blueAccent)),
                onPressed: () {
                },
              ),
            )
          else
            Expanded(child: Text('Not uploaded', style: TextStyle(color: Colors.grey[500]))),
        ],
      ),
    );
  }

  void _showCompanyProfilePreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => CompanyProfilePreviewScreen(profileData: _profileData!),
    );
  }

  void _editCompanyProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCompanyProfileScreen(profileData: _profileData!),
      ),
    ).then((_) => _loadProfile());
  }
}