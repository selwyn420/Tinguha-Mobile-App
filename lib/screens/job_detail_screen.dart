import 'package:flutter/material.dart';
import '../../models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.jobTitle, style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            const SizedBox(height: 16.0),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.companyName, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Row(children: [Icon(Icons.location_on, size: 16, color: Colors.grey[500]), const SizedBox(width: 4.0), Text(job.location, style: TextStyle(fontSize: 14.0, color: Colors.grey[600]))]),
                    const SizedBox(height: 4.0),
                    Row(children: [Icon(Icons.work, size: 16, color: Colors.grey[500]), const SizedBox(width: 4.0), Text(job.employmentType, style: TextStyle(fontSize: 14.0, color: Colors.grey[600]))]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            
            const Text('Job Description', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            const SizedBox(height: 8.0),
            Text(job.jobDescription, style: TextStyle(fontSize: 14.0, color: Colors.grey[700], height: 1.5)),
            const SizedBox(height: 20.0),
            
            const Text('Requirements', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            const SizedBox(height: 8.0),
            Text(job.requirements, style: TextStyle(fontSize: 14.0, color: Colors.grey[700], height: 1.5)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application submitted!')));
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
          child: const Text('Apply Now', style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }
}