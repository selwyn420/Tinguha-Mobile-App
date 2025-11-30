import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../services/job_service.dart';
import 'post_job_screen.dart';

class CompanyJobPostingsScreen extends StatefulWidget {
  final String companyId;
  const CompanyJobPostingsScreen({super.key, required this.companyId});

  @override
  State<CompanyJobPostingsScreen> createState() => _CompanyJobPostingsScreenState();
}

class _CompanyJobPostingsScreenState extends State<CompanyJobPostingsScreen> {
  final JobService _jobService = JobService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Job Postings'), backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
      body: StreamBuilder<List<JobModel>>(
        stream: _jobService.getJobsByCompany(widget.companyId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) return _buildEmptyState();
          return ListView.builder(padding: const EdgeInsets.all(16.0), itemCount: jobs.length, itemBuilder: (context, index) => _buildJobCard(jobs[index]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PostJobScreen())),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.jobTitle, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                Text(job.location, style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
                const SizedBox(width: 16.0),
                Icon(Icons.work, size: 16, color: Colors.grey[500]),
                Text(job.employmentType, style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                _buildStatusChip(job.status),
                const Spacer(),
                Text('0 applications', style: TextStyle(fontSize: 12.0, color: Colors.grey[500])),
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
      case 'active': chipColor = Colors.green; statusText = 'Active'; break;
      case 'draft': chipColor = Colors.orange; statusText = 'Draft'; break;
      case 'closed': chipColor = Colors.red; statusText = 'Closed'; break;
      default: chipColor = Colors.grey; statusText = 'Unknown';
    }
    return Chip(label: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 12)), backgroundColor: chipColor);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(Icons.work_outline, size: 64, color: Colors.grey),
        SizedBox(height: 16.0),
        Text('No job postings yet', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        Text('Tap + to create your first job posting', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
      ]),
    );
  }
}