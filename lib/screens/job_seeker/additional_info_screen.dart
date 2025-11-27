import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dashboard_screen.dart';

class EducationalBackgroundScreen extends StatefulWidget {
  const EducationalBackgroundScreen({super.key});

  @override
  State<EducationalBackgroundScreen> createState() => _EducationalBackgroundScreenState();
}

class _EducationalBackgroundScreenState extends State<EducationalBackgroundScreen> {
  final _formKey = GlobalKey<FormState>();
  final _elementaryController = TextEditingController();
  final _highSchoolController = TextEditingController();
  final _collegeController = TextEditingController();
  final _reference1Controller = TextEditingController();
  final _reference2Controller = TextEditingController();
  final _reference3Controller = TextEditingController();
  final _skillsController = TextEditingController();
  final _aboutController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _diplomaFileName;
  String? _credentialsFileName;
  String? _diplomaLocalPath;
  String? _credentialsLocalPath;

  Future<void> _pickFile(String type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() => _isLoading = true);

        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId == null) throw Exception('User not logged in');

        final file = result.files.first;
        if (file.bytes == null) throw Exception('File is empty');

        // Save to local storage
        final directory = await getApplicationDocumentsDirectory();
        final folderPath = '${directory.path}/job_seeker_files/$userId/$type';
        final folder = Directory(folderPath);
        if (!await folder.exists()) {
          await folder.create(recursive: true);
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        final filePath = '$folderPath/$fileName';
        final savedFile = File(filePath);
        await savedFile.writeAsBytes(file.bytes!);

        setState(() {
          if (type == 'diploma') {
            _diplomaLocalPath = filePath;
            _diplomaFileName = file.name;
          } else {
            _credentialsLocalPath = filePath;
            _credentialsFileName = file.name;
          }
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'File save failed: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAndFinish() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final references = [
        _reference1Controller.text.trim(),
        _reference2Controller.text.trim(),
        _reference3Controller.text.trim(),
      ].where((ref) => ref.isNotEmpty).toList();

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('job_seekers')
          .doc(userId)
          .set({
        'educational_background': {
          'elementary': _elementaryController.text.trim(),
          'high_school': _highSchoolController.text.trim(),
          'college': _collegeController.text.trim(),
          'references': references,
          'skills': _skillsController.text.trim(),
          'about_yourself': _aboutController.text.trim(),
          'diploma_local_path': _diplomaLocalPath,
          'credentials_local_path': _credentialsLocalPath,
          'updated_at': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to save: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Educational Background'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Educational Background',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 24.0),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              // Elementary
              TextFormField(
                controller: _elementaryController,
                decoration: InputDecoration(
                  labelText: 'Elementary *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // High School
              TextFormField(
                controller: _highSchoolController,
                decoration: InputDecoration(
                  labelText: 'High School *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // College
              TextFormField(
                controller: _collegeController,
                decoration: InputDecoration(
                  labelText: 'College *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),

              Text(
                'Character References',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 24.0),

              // Reference 1
              TextFormField(
                controller: _reference1Controller,
                decoration: InputDecoration(
                  labelText: '1st Reference (Name & Contact)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Reference 2
              TextFormField(
                controller: _reference2Controller,
                decoration: InputDecoration(
                  labelText: '2nd Reference (Name & Contact)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Reference 3
              TextFormField(
                controller: _reference3Controller,
                decoration: InputDecoration(
                  labelText: '3rd Reference (Name & Contact)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),

              // Skills Section
              Text(
                'Skills',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _skillsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'List your skills...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please list at least one skill';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),

              // About Yourself (Optional)
              Text(
                'About Yourself (Optional)',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _aboutController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),

              // Diploma Section
              Text(
                'Diploma / Transcript of Records',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16.0),

              // Upload Diploma Button
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _pickFile('diploma'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file),
                      SizedBox(width: 8.0),
                      Text(_diplomaFileName ?? 'Upload Diploma/PDF'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Other Credentials
              Text(
                'Other Credentials',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16.0),

              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _pickFile('credentials'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file),
                      SizedBox(width: 8.0),
                      Text(_credentialsFileName ?? 'Upload Credentials'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.0),

              // Finish Button
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAndFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Finish',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}