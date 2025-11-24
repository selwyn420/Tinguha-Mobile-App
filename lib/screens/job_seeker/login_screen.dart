import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';

class JobSeekerLogin extends StatelessWidget {
  const JobSeekerLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOG IN'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:Icon(
              Icons.person_outline_rounded,
              size: 200,
              color: Colors.blueAccent,
                )
              ),
            SizedBox(height: 16.0),
            
            // Email Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Password Field
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Remember Me and Forgot Password Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: false, // You'll need to manage state for this
                      onChanged: (value) {},
                      activeColor: Colors.blueAccent,
                    ),
                    Text('Remember Me'),
                  ],
                ),
                
                // Forgot Password
                TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            
            // Terms and Conditions
            Center(
              child: TextButton(
                onPressed: () {
                  // Show terms and conditions
                },
                child: Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            
            // LOGIN Button
            SizedBox(
              width: double.infinity,
              height: 40.0,
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
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),

            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // SIGN UP AS JOB SEEKER Button
            SizedBox(
              width: double.infinity,
              height: 40.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobSeekerSignup()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  elevation: 1,
                  side: BorderSide(color: Colors.blueAccent, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'SIGN UP AS JOB SEEKER',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}