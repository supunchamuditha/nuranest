import 'package:flutter/material.dart';
import 'package:nuranest/psychologist_screens/psychologist_login_screen.dart';

class PsychologistFormScreen extends StatefulWidget {
  const PsychologistFormScreen({super.key});

  @override
  _PsychologistFormScreenState createState() => _PsychologistFormScreenState();
}

class _PsychologistFormScreenState extends State<PsychologistFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your username',
                _usernameController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              Text('Email', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your email',
                _emailController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              Text('Phone', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your phone number',
                _phoneController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required.';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Enter a valid phone number.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              Text('Birthday', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your birthday',
                _birthdayController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Birthday is required.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              Text('Gender', style: _sectionTitleStyle()),
              _buildGenderButtons(),

              SizedBox(height: 10),
              Text('Address', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your address',
                _addressController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              Text('Qualifications', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your qualifications',
                _qualificationsController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Qualifications are required.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              Text('Specialization', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your specialization',
                _specializationController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Specialization is required.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),
              // Save Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // _validateAndSaveProfile();
                    if (_formKey.currentState!.validate() &&
                        _validateAndSaveProfile()) {
                      // Process the form
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Profile saved successfully!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 239, 222, 214),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
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
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.black),
        // labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      validator: validator,
    );
  }

  String? _genderError;

// Gender selection buttons
  Widget _buildGenderButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedGender = 'Male';
                    _genderError = null; // Clear error when selected
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: _selectedGender == 'Male'
                      ? Colors.blue[100]
                      : Colors.white,
                  side: BorderSide(
                    color: _genderError != null
                        ? Colors.red
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
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
                    _genderError = null; // Clear error when selected
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: _selectedGender == 'Female'
                      ? Colors.blue[100]
                      : Colors.white,
                  side: BorderSide(
                    color: _genderError != null
                        ? Colors.red
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
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
        ),
        if (_genderError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _genderError!,
              style: TextStyle(color: Colors.red, fontSize: 12),
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

// Validate gender before saving the profile
  bool _validateAndSaveProfile() {
    bool isValid = true;
    setState(() {
      if (_selectedGender == null) {
        _genderError = 'Please select your gender.';
        isValid = false;
      } else {
        _genderError = null;
      }
    });
    return isValid;
  }
}
