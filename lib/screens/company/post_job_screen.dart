import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../services/job_service.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobService = JobService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;
  
  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _employmentTypeController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _requirementsController = TextEditingController();

  Future<void> _publishJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final job = JobModel(
        id: _firestore.collection('jobs').doc().id,
        jobTitle: _jobTitleController.text.trim(),
        companyName: _companyNameController.text.trim(),
        location: _locationController.text.trim(),
        employmentType: _employmentTypeController.text.trim(),
        jobDescription: _jobDescriptionController.text.trim(),
        requirements: _requirementsController.text.trim(),
        status: 'active',
        postedDate: DateTime.now(),
        companyId: currentUserId!, 
      );

      await _jobService.publishJob(job);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job published successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post New Job'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    TextFormField(controller: _jobTitleController, decoration: InputDecoration(labelText: 'Job Title *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), filled: true, fillColor: Colors.grey[50]), validator: (value) => value?.isEmpty ?? true ? 'Required' : null),
                    const SizedBox(height: 20),
                    const Text('Basic Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    const SizedBox(height: 12),
                    TextFormField(controller: _companyNameController, decoration: InputDecoration(labelText: 'Company Name *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), filled: true, fillColor: Colors.grey[50]), validator: (value) => value?.isEmpty ?? true ? 'Required' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _locationController, decoration: InputDecoration(labelText: 'Location *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), filled: true, fillColor: Colors.grey[50]), validator: (value) => value?.isEmpty ?? true ? 'Required' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _employmentTypeController, decoration: InputDecoration(labelText: 'Employment Type *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), filled: true, fillColor: Colors.grey[50]), validator: (value) => value?.isEmpty ?? true ? 'Required' : null),
                    const SizedBox(height: 20),
                    const Text('Job Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    const SizedBox(height: 12),
                    TextFormField(controller: _jobDescriptionController, maxLines: 8, decoration: InputDecoration(hintText: 'Describe the role...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), filled: true, fillColor: Colors.grey[50]), validator: (value) => value?.isEmpty ?? true ? 'Required' : null),
                    const SizedBox(height: 20),
                    const Text('Requirements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    const SizedBox(height: 12),
                    TextFormField(controller: _requirementsController, maxLines: 8, decoration: InputDecoration(hintText: 'List qualifications...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)), filled: true, fillColor: Colors.grey[50]), validator: (value) => value?.isEmpty ?? true ? 'Required' : null),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black, blurRadius: 8, offset: const Offset(0, -2))]),
              child: Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: _saveDraft, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), side: const BorderSide(color: Colors.blueAccent)), child: const Text('Save Draft', style: TextStyle(fontSize: 16, color: Colors.blueAccent)))),
                  const SizedBox(width: 16),
                  Expanded(child: ElevatedButton(onPressed: _isLoading ? null : _publishJob, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))), child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Publish Job', style: TextStyle(fontSize: 16, color: Colors.white)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _employmentTypeController.dispose();
    _jobDescriptionController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }
}