import 'package:flutter/material.dart';

class ProfilePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> personalInfo;
  final Map<String, dynamic> educationalBackground;

  const ProfilePreviewScreen({
    super.key,
    required this.personalInfo,
    required this.educationalBackground,
  });

  @override
  Widget build(BuildContext context) {
    final references = List<String>.from(educationalBackground['references'] ?? []);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How Employers See Your Profile',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          // Profile Preview Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Picture in Preview
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 48, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '${personalInfo['first_name'] ?? 'Not provided'} ${personalInfo['last_name'] ?? ''}'.trim(),
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${personalInfo['region'] ?? 'Not provided'} • ${personalInfo['municipality_zip_code'] ?? ''}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16.0),

                  // Applicant Information in Preview
                  _buildPreviewSection('Applicant Information', [
                    _buildPreviewInfoRow('Name:', '${personalInfo['first_name']} ${personalInfo['middle_name']} ${personalInfo['last_name']}'),
                    _buildPreviewInfoRow('Date of Birth:', personalInfo['date_of_birth']),
                    _buildPreviewInfoRow('Address:', personalInfo['permanent_address']),
                  ]),

                  SizedBox(height: 16.0),

                  // Contact Information in Preview
                  _buildPreviewSection('Contact Information', [
                    _buildPreviewInfoRow('Email:', 'user@example.com'), // In real app, get from Auth
                    _buildPreviewInfoRow('Phone:', personalInfo['phone_number']),
                  ]),

                  SizedBox(height: 16.0),

                  // Educational Background
                  _buildPreviewSection('Education', [
                    _buildPreviewInfoRow('Elementary:', educationalBackground['elementary']),
                    _buildPreviewInfoRow('High School:', educationalBackground['high_school']),
                    _buildPreviewInfoRow('College:', educationalBackground['college']),
                  ]),

                  SizedBox(height: 16.0),

                  // Skills
                  _buildPreviewSection('Skills', [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        educationalBackground['skills'] ?? 'No skills listed',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ]),

                  SizedBox(height: 16.0),

                  // References
                  if (references.isNotEmpty)
                    _buildPreviewSection('References', 
                      references.map((ref) => _buildPreviewInfoRow('•', ref)).toList(),
                    ),

                  SizedBox(height: 16.0),

                  // Note
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blueAccent, size: 20),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'This is how employers see your profile',
                            style: TextStyle(fontSize: 14.0, color: Colors.blue[800]),
                          ),
                        ),
                      ],
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

  Widget _buildPreviewSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            SizedBox(height: 12.0),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value?.isNotEmpty ?? false ? value! : 'Not provided'),
          ),
        ],
      ),
    );
  }
}