import 'package:flutter/material.dart';

class CompanyProfilePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const CompanyProfilePreviewScreen({
    super.key,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
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
                'How Candidates See Your Company',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 16.0),

          // Company Profile Preview Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Company Logo in Preview
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.business, size: 48, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    profileData['company_name'] ?? 'Company Name',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${profileData['address'] ?? 'Not provided'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16.0),

                  // Company Information in Preview
                  _buildPreviewSection('Company Information', [
                    _buildPreviewInfoRow('Industry:', profileData['industry']),
                    _buildPreviewInfoRow('Company Size:', profileData['company_size']),
                    _buildPreviewInfoRow('Location:', profileData['address']),
                  ]),

                  SizedBox(height: 16.0),

                  // Contact Information in Preview
                  _buildPreviewSection('Contact Information', [
                    _buildPreviewInfoRow('Email:', 'company@example.com'), // Get from Auth in real app
                    _buildPreviewInfoRow('Phone:', profileData['phone_number']),
                    _buildPreviewInfoRow('Website:', profileData['website']),
                  ]),

                  SizedBox(height: 16.0),

                  // About Company in Preview
                  if (profileData['about_company'] != null)
                    _buildPreviewSection('About Company', [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          profileData['about_company'],
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ]),

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
                            'This is how job candidates see your company profile',
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
          SizedBox(width: 100, child: Text(label, style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value?.isNotEmpty ?? false ? value! : 'Not provided')),
        ],
      ),
    );
  }
}