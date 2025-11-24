import 'package:flutter/material.dart';
import 'job_seeker/login_signup_screen.dart';
import 'company/login_signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full blue background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blueAccent,
          ),
          
          // White container at bottom for buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 40.0, left: 32.0, right: 32.0),
                child: Column(
                  children: [
                    // Sign Up as Jobseeker Button
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JSLoginSignupScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'JOBSEEKER',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16.0),
                    
                    // Sign Up as Company Button
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CLoginSignupScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'COMPANY',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Centered content in blue area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Magnifying glass Logo
                Icon(
                  Icons.search,
                  size: 240.0,
                  color: Colors.white,
                ), // Logo
                
                SizedBox(height: 24.0),
                
                // TINGUHA Logo/Title
                Text(
                  'TINGUHA',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    height: 1.2,
                  ),
                ),
                
                SizedBox(height: 12.0),
                
                // The Next Opportunity tagline
                Text(
                  'The Next Opportunity',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                    letterSpacing: 0.8,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}