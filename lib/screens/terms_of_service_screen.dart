import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20.0),

            _buildSection('1. Acceptance of Terms',
                'By accessing and using the Tinguha job search platform, you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.'),

            _buildSection('2. User Accounts',
                'You must provide accurate and complete information when creating an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must be at least 18 years old to use this service.'),

            _buildSection('3. User Responsibilities',
                'Users agree to:\n• Provide accurate profile information\n• Not post false or misleading job listings\n• Respect other users and communicate professionally\n• Not use the platform for any illegal purposes\n• Maintain the confidentiality of sensitive information\n\nWe reserve the right to suspend or terminate accounts that violate these terms.'),

            _buildSection('4. Privacy and Data Protection',
                'We collect and process personal data in accordance with our Privacy Policy. By using Tinguha, you consent to the collection, use, and storage of your data as described in our Privacy Policy. Users retain ownership of their data but grant us a license to use it for platform operations.'),

            _buildSection('5. Intellectual Property',
                'All content uploaded to Tinguha remains the property of the user. However, you grant us a non-exclusive, worldwide license to use, display, and distribute your content for the purpose of operating the platform. The Tinguha brand, logo, and platform design are our exclusive property.'),

            _buildSection('6. Limitation of Liability',
                'Tinguha provides this platform "as is" without any warranties. We do not guarantee job placements or the accuracy of user-provided information. We are not liable for any direct, indirect, incidental, or consequential damages arising from your use of the platform. We are not responsible for interactions between users.'),

            _buildSection('7. Modifications to Terms',
                'We may update these Terms of Service periodically. Continued use of the platform after changes constitutes acceptance of the new terms. We will notify users of significant changes via email or in-app notification.'),

            _buildSection('8. Termination',
                'We reserve the right to terminate or suspend accounts at our discretion, especially for violations of these terms. Users may delete their accounts at any time through the profile settings. Upon termination, we will delete your personal data in accordance with our data retention policy.'),

            _buildSection('9. Dispute Resolution',
                'Any disputes arising from these terms will be resolved through binding arbitration in the Philippines. Both parties agree to arbitration before pursuing other legal remedies.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: TextStyle(fontSize: 14.0, height: 1.5, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}