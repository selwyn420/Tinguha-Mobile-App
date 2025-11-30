import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../services/application_service.dart';

class JobDetailScreen extends StatefulWidget {
  final JobModel job;
  final String currentUserId;

  const JobDetailScreen({
    super.key,
    required this.job,
    required this.currentUserId,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final ApplicationService _applicationService = ApplicationService();
  bool _hasApplied = false;
  bool _isCheckingStatus = true;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    try {
      final hasApplied = await _applicationService.hasUserApplied(
        widget.currentUserId,
        widget.job.id,
      );
      if (mounted) {
        setState(() {
          _hasApplied = hasApplied;
          _isCheckingStatus = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCheckingStatus = false);
      }
    }
  }

  Future<void> _applyForJob() async {
    setState(() => _isApplying = true);
    
    try {
      await _applicationService.applyForJob(widget.currentUserId, widget.job);
      
      if (mounted) {
        setState(() {
          _hasApplied = true;
          _isApplying = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isApplying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

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
            Text(
              widget.job.jobTitle,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 16.0),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.job.companyName, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4.0),
                        Text(widget.job.location, style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.work, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4.0),
                        Text(widget.job.employmentType, style: TextStyle(fontSize: 14.0, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            
            const Text(
              'Job Description',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.job.jobDescription,
              style: TextStyle(fontSize: 14.0, color: Colors.grey[700], height: 1.5),
            ),
            const SizedBox(height: 20.0),
            
            const Text(
              'Requirements',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.job.requirements,
              style: TextStyle(fontSize: 14.0, color: Colors.grey[700], height: 1.5),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: _isCheckingStatus
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: _hasApplied || _isApplying ? null : _applyForJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasApplied ? Colors.grey : const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                child: _isApplying
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _hasApplied ? 'Already Applied' : 'Apply Now',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
      ),
    );
  }
}