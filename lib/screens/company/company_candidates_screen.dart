import 'package:flutter/material.dart';
import '../../models/application_model.dart';
import '../../services/application_service.dart';

class CompanyCandidatesScreen extends StatefulWidget {
  final String companyId;
  const CompanyCandidatesScreen({super.key, required this.companyId});

  @override
  State<CompanyCandidatesScreen> createState() => _CompanyCandidatesScreenState();
}

class _CompanyCandidatesScreenState extends State<CompanyCandidatesScreen> {
  final ApplicationService _applicationService = ApplicationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Candidates'), backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
      body: StreamBuilder<List<ApplicationModel>>(
        stream: _applicationService.getApplicationsByCompany(widget.companyId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final applications = snapshot.data ?? [];
          if (applications.isEmpty) return _buildEmptyState();
          return ListView.builder(padding: const EdgeInsets.all(16.0), itemCount: applications.length, itemBuilder: (context, index) => _buildCandidateCard(applications[index]));
        },
      ),
    );
  }

  Widget _buildCandidateCard(ApplicationModel application) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(application.jobTitle ?? 'Unknown Job', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            const SizedBox(height: 8.0),
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.blueAccent, child: const Icon(Icons.person, color: Colors.white, size: 20)),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Candidate ID: ${application.userId}', style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
                      Text('Applied: ${_formatTimestamp(application.appliedDate)}', style: TextStyle(fontSize: 12.0, color: Colors.grey[500])),
                    ],
                  ),
                ),
                _buildStatusDropdown(application),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(ApplicationModel application) {
    return DropdownButton<String>(
      value: application.status,
      underline: Container(),
      icon: const Icon(Icons.arrow_drop_down, size: 20),
      onChanged: (String? newStatus) {
        if (newStatus != null && newStatus != application.status) {
          _applicationService.updateApplicationStatus(application.id, newStatus);
        }
      },
      items: <String>['pending', 'reviewing', 'interview', 'accepted', 'rejected']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value.toUpperCase(), style: TextStyle(fontSize: 12.0, color: _getStatusColor(value), fontWeight: FontWeight.bold)),
        );
      }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'reviewing': return Colors.blue;
      case 'interview': return Colors.purple;
      case 'accepted': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(Icons.people_outline, size: 64, color: Colors.grey),
        SizedBox(height: 16.0),
        Text('No candidates yet', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        Text('Candidates will appear here when they apply', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
      ]),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'now';
  }
}