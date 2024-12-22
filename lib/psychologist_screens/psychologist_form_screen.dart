import 'package:flutter/material.dart';
import 'package:nuranest/psychologist_screens/psychologist_login_screen.dart';

class PsychologistFormScreen extends StatefulWidget {
  const PsychologistFormScreen({super.key});

  @override
  _PsychologistFormScreenState createState() => _PsychologistFormScreenState();
}

class _PsychologistFormScreenState extends State<PsychologistFormScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _qualificationsController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();

  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Psychologist Profile Setup',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username', style: _sectionTitleStyle()),
            _buildTextField('Enter your username', _usernameController),

            SizedBox(height: 10),
            Text('Email', style: _sectionTitleStyle()),
            _buildTextField('Enter your email', _emailController),

            SizedBox(height: 10),
            Text('Phone', style: _sectionTitleStyle()),
            _buildTextField('Enter your phone number', _phoneController),

            SizedBox(height: 10),
            Text('Birthday', style: _sectionTitleStyle()),
            _buildTextField('Enter your birthday', _birthdayController),

            SizedBox(height: 10),
            Text('Gender', style: _sectionTitleStyle()),
            _buildGenderButtons(),

            SizedBox(height: 10),
            Text('Address', style: _sectionTitleStyle()),
            _buildTextField('Enter your address', _addressController),

            SizedBox(height: 10),
            Text('Qualifications', style: _sectionTitleStyle()),
            _buildTextField(
                'Enter your qualifications', _qualificationsController),

            SizedBox(height: 10),
            Text('Specialization', style: _sectionTitleStyle()),
            _buildTextField(
                'Enter your specialization', _specializationController),

            SizedBox(height: 30),
            // Save Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PsychologistLoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 239, 222, 214),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      maxLines: maxLines,
    );
  }

  // Gender selection buttons
  Widget _buildGenderButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedGender = 'Male';
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  _selectedGender == 'Male' ? Colors.blue[100] : Colors.white,
              side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Male',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedGender = 'Female';
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  _selectedGender == 'Female' ? Colors.blue[100] : Colors.white,
              side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Female',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // Helper function for section title style
  TextStyle _sectionTitleStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }
}
