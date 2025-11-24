import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class EducationalBackgroundScreen extends StatelessWidget {
  const EducationalBackgroundScreen({super.key});

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
            
            // Elementary
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Elementary',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // High School
            TextFormField(
              decoration: InputDecoration(
                labelText: 'High School',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // College
            TextFormField(
              decoration: InputDecoration(
                labelText: 'College',
                border: OutlineInputBorder(),
              ),
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
            
            // Elementary
            TextFormField(
              decoration: InputDecoration(
                labelText: '1st Reference',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // High School
            TextFormField(
              decoration: InputDecoration(
                labelText: '2nd Reference',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // College
            TextFormField(
              decoration: InputDecoration(
                labelText: '3rd Reference',
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
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'List your skills...',
                border: OutlineInputBorder(),
              ),
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
            
            // Upload File Button
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  // Handle file upload
                },
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
                    Text('Upload File'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),

            Text(
              'Other Credentials',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent
                ),
              ),
            SizedBox(height: 16.0),

            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  // Handle file upload
                },
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
                    Text('Upload File'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.0),
            
            // Finish Button
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DashboardScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}