import 'package:flutter/material.dart';
import 'package:glam1/widgets/CustomButton.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GoGlam',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'AI-Powered Booking for Makeup Artists',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'Streamline your bookings with WhatsApp & Instagram',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            CustomButton(
              icon: Icons.mail,
              text: 'Continue with Email',
              onPressed: () {
                // Handle email login
              },
            ),
            SizedBox(height: 8),
            CustomButton(
              icon: Icons.g_translate,
              text: 'Continue with Google',
              onPressed: () {
                // Handle Google login
              },
            ),
            SizedBox(height: 8),
            CustomButton(
              icon: Icons.apple,
              text: 'Continue with Apple',
              onPressed: () {
                // Handle Apple login
              },
            ),
            SizedBox(height: 8),
            CustomButton(
              icon: Icons.facebook,
              text: 'Continue with Facebook',
              onPressed: () {
                // Handle Facebook login
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: 'English',
                  onChanged: (String? newValue) {
                    // Handle language change
                  },
                  items: <String>['English', 'Spanish', 'French']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: 'USA',
                  onChanged: (String? newValue) {
                    // Handle country change
                  },
                  items: <String>['USA', 'Canada', 'UK']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'By continuing, you agree to our Terms of Service and Privacy',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
