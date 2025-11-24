import 'package:flutter/material.dart';
import 'additional_info_screen.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 24.0),
            
            // First Name
            TextFormField(
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Middle Name
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Last Name
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Date of Birth
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
                hintText: '01/07/2025',
              ),
              readOnly: true,
              onTap: () {
                // Show date picker
                _selectDate(context);
              },
            ),
            SizedBox(height: 16.0),
            
            // Permanent Address
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Permanent Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Region Province
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Municipality Zip Code
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Municipality Zip Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Phone Number
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 32.0),
            
            // Next Button
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push( 
                    context, 
                    MaterialPageRoute(builder: (context) => EducationalBackgroundScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // Update the date field here
    }
  }
}