import 'package:flutter/material.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _employmentTypeController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _requirementsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post New Job'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Scrollable form fields
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Job Title
                    TextFormField(
                      controller: _jobTitleController,
                      decoration: InputDecoration(
                        labelText: 'Job Title *',
                        hintText: 'e.g., Marketing Assistant, Data Analyst',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    const SizedBox(height: 20),

                    // Basic Information Section
                    const Text('Basic Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _companyNameController,
                      decoration: InputDecoration(
                        labelText: 'Company Name *',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location *',
                        hintText: 'e.g., New York, NY or Remote',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _employmentTypeController,
                      decoration: InputDecoration(
                        labelText: 'Employment Type *',
                        hintText: 'e.g., Full-time, Part-time, Contract',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    const SizedBox(height: 20),

                    // Job Description Section
                    const Text('Job Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _jobDescriptionController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Describe the role, responsibilities, and duties...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.grey[50],
                        alignLabelWithHint: true,
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    const SizedBox(height: 20),

                    // Requirements Section
                    const Text('Requirements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _requirementsController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'List qualifications, skills, and experience needed...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.grey[50],
                        alignLabelWithHint: true,
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                    const SizedBox(height: 20), // Space before buttons
                  ],
                ),
              ),
            ),
            
            // FIXED BOTTOM BUTTONS
            Container(
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
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                      ),
                      child: const Text('Save Draft', style: TextStyle(fontSize: 16, color: Color(0xFF2563EB))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _publishJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      child: const Text('Publish Job', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDraft() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  void _publishJob() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job published successfully')),
      );
      Navigator.pop(context);
    }
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