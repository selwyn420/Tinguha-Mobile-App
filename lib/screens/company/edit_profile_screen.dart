import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditCompanyProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const EditCompanyProfileScreen({super.key, required this.profileData});

  @override
  State<EditCompanyProfileScreen> createState() => _EditCompanyProfileScreenState();
}

class _EditCompanyProfileScreenState extends State<EditCompanyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  late TextEditingController _companyNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _aboutController;
  late TextEditingController _industryController;
  late TextEditingController _companySizeController;
  late TextEditingController _websiteController;

  bool _isLoading = false;
  String? _errorMessage;
  String? _certificateFileName;
  String? _certificateLocalPath;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.profileData['company_name'] ?? '');
    _phoneController = TextEditingController(text: widget.profileData['phone_number'] ?? '');
    _addressController = TextEditingController(text: widget.profileData['address'] ?? '');
    _aboutController = TextEditingController(text: widget.profileData['about_company'] ?? '');
    _industryController = TextEditingController(text: widget.profileData['industry'] ?? '');
    _companySizeController = TextEditingController(text: widget.profileData['company_size'] ?? '');
    _websiteController = TextEditingController(text: widget.profileData['website'] ?? '');
    _certificateLocalPath = widget.profileData['certificate_local_path'];
    _certificateFileName = widget.profileData['certificate_file_name'] ?? 'No file';
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _aboutController.dispose();
    _industryController.dispose();
    _companySizeController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickCertificate() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() => _isLoading = true);

        final file = result.files.first;
        if (file.bytes == null) throw Exception('File is empty');

        final directory = await getApplicationDocumentsDirectory();
        final folderPath = '${directory.path}/company_files/$userId/certificates';
        final folder = Directory(folderPath);
        if (!await folder.exists()) {
          await folder.create(recursive: true);
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        final filePath = '$folderPath/$fileName';
        final savedFile = File(filePath);
        await savedFile.writeAsBytes(file.bytes!);

        setState(() {
          _certificateLocalPath = filePath;
          _certificateFileName = file.name;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'File save failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _firestore.collection('companies').doc(userId).set({
        'company_name': _companyNameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'about_company': _aboutController.text.trim(),
        'industry': _industryController.text.trim(),
        'company_size': _companySizeController.text.trim(),
        'website': _websiteController.text.trim(),
        'certificate_local_path': _certificateLocalPath,
        'certificate_file_name': _certificateFileName,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company profile updated successfully!')),
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
        title: const Text('Edit Company Profile'),
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
              'Edit Company Information',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 24.0),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ),

            TextFormField(controller: _companyNameController, decoration: const InputDecoration(labelText: 'Company Name *'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _industryController, decoration: const InputDecoration(labelText: 'Industry')),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _companySizeController, decoration: const InputDecoration(labelText: 'Company Size (e.g., 50-100 employees)')),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number *'), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Company Address *'), maxLines: 2, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _websiteController, decoration: const InputDecoration(labelText: 'Website (Optional)'), keyboardType: TextInputType.url),
            const SizedBox(height: 16.0),
            
            TextFormField(controller: _aboutController, decoration: const InputDecoration(labelText: 'About Your Company (Optional)'), maxLines: 4),
            const SizedBox(height: 24.0),

            // Certificate Upload
            const Text('Certificate of Registration', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Card(
              child: ListTile(
                leading: Icon(Icons.file_present, color: Colors.blueAccent),
                title: Text(_certificateFileName ?? 'No file uploaded'),
                trailing: IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: _isLoading ? null : _pickCertificate,
                ),
              ),
            ),
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