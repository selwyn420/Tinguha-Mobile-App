import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; 

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const EditProfileScreen({super.key, required this.profileData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _regionController;
  late TextEditingController _zipCodeController;
  late TextEditingController _phoneController;
  late TextEditingController _elementaryController;
  late TextEditingController _highSchoolController;
  late TextEditingController _collegeController;
  late TextEditingController _reference1Controller;
  late TextEditingController _reference2Controller;
  late TextEditingController _reference3Controller;
  late TextEditingController _skillsController;
  late TextEditingController _aboutController;

  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final personalInfo = widget.profileData['personal_info'] ?? {};
    final educationalBackground = widget.profileData['educational_background'] ?? {};
    final references = List<String>.from(educationalBackground['references'] ?? ['', '', '']);

    _firstNameController = TextEditingController(text: personalInfo['first_name'] ?? '');
    _middleNameController = TextEditingController(text: personalInfo['middle_name'] ?? '');
    _lastNameController = TextEditingController(text: personalInfo['last_name'] ?? '');
    _addressController = TextEditingController(text: personalInfo['permanent_address'] ?? '');
    _regionController = TextEditingController(text: personalInfo['region'] ?? '');
    _zipCodeController = TextEditingController(text: personalInfo['municipality_zip_code'] ?? '');
    _phoneController = TextEditingController(text: personalInfo['phone_number'] ?? '');
    
    _elementaryController = TextEditingController(text: educationalBackground['elementary'] ?? '');
    _highSchoolController = TextEditingController(text: educationalBackground['high_school'] ?? '');
    _collegeController = TextEditingController(text: educationalBackground['college'] ?? '');
    _reference1Controller = TextEditingController(text: references.length > 0 ? references[0] : '');
    _reference2Controller = TextEditingController(text: references.length > 1 ? references[1] : '');
    _reference3Controller = TextEditingController(text: references.length > 2 ? references[2] : '');
    _skillsController = TextEditingController(text: educationalBackground['skills'] ?? '');
    _aboutController = TextEditingController(text: educationalBackground['about_yourself'] ?? '');

    if (personalInfo['date_of_birth'] != null) {
      _selectedDate = DateTime.parse(personalInfo['date_of_birth']);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    _elementaryController.dispose();
    _highSchoolController.dispose();
    _collegeController.dispose();
    _reference1Controller.dispose();
    _reference2Controller.dispose();
    _reference3Controller.dispose();
    _skillsController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.blueAccent),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      setState(() => _errorMessage = 'Please select date of birth');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final references = [
        _reference1Controller.text.trim(),
        _reference2Controller.text.trim(),
        _reference3Controller.text.trim(),
      ].where((ref) => ref.isNotEmpty).toList();

      await _firestore.collection('job_seekers').doc(userId).set({
        'personal_info': {
          'first_name': _firstNameController.text.trim(),
          'middle_name': _middleNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'date_of_birth': _selectedDate!.toIso8601String(),
          'permanent_address': _addressController.text.trim(),
          'region': _regionController.text.trim(),
          'municipality_zip_code': _zipCodeController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'updated_at': FieldValue.serverTimestamp(),
        },
        'educational_background': {
          'elementary': _elementaryController.text.trim(),
          'high_school': _highSchoolController.text.trim(),
          'college': _collegeController.text.trim(),
          'references': references,
          'skills': _skillsController.text.trim(),
          'about_yourself': _aboutController.text.trim(),
          'updated_at': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to save: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Text(
              'Edit Profile Information',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 24.0),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),

            // Personal Information
            const Text('Personal Information', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _middleNameController, decoration: const InputDecoration(labelText: 'Middle Name')),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            // Date of Birth
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date of Birth *',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDate == null ? '' : DateFormat('MM/dd/yyyy').format(_selectedDate!),
              ),
              onTap: () => _selectDate(context),
              validator: (value) => _selectedDate == null ? 'Required' : null,
            ),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Permanent Address *'), maxLines: 2, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _regionController, decoration: const InputDecoration(labelText: 'Region *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _zipCodeController, decoration: const InputDecoration(labelText: 'Municipality Zip Code *'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number *'), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 24.0),

            // Educational Background
            const Text('Educational Background', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _elementaryController, decoration: const InputDecoration(labelText: 'Elementary *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _highSchoolController, decoration: const InputDecoration(labelText: 'High School *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _collegeController, decoration: const InputDecoration(labelText: 'College *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 24.0),

            // References
            const Text('Character References', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _reference1Controller, decoration: const InputDecoration(labelText: '1st Reference (Name & Contact)')),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _reference2Controller, decoration: const InputDecoration(labelText: '2nd Reference (Name & Contact)')),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _reference3Controller, decoration: const InputDecoration(labelText: '3rd Reference (Name & Contact)')),
            const SizedBox(height: 24.0),

            // Skills
            const Text('Skills', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            TextFormField(controller: _skillsController, maxLines: 3, decoration: const InputDecoration(hintText: 'List your skills...'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 24.0),

            // About Yourself
            const Text('About Yourself', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            TextFormField(controller: _aboutController, maxLines: 4, decoration: const InputDecoration(hintText: 'Tell us about yourself...')),
            const SizedBox(height: 32.0),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}