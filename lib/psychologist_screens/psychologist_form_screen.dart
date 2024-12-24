import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv package
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import the convert package
import 'package:nuranest/psychologist_screens/psychologist_login_screen.dart';

class PsychologistFormScreen extends StatefulWidget {
  const PsychologistFormScreen({super.key});

  @override
  _PsychologistFormScreenState createState() => _PsychologistFormScreenState();
}

class _PsychologistFormScreenState extends State<PsychologistFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define the text editing controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _qualificationsController =
      TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _workplaceController = TextEditingController();
  final TextEditingController _consultationFeeController =
      TextEditingController();

  String? _selectedGender;

  // Define the loading state
  bool isLoading = false;

  // Define the _showMessage method
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    try {
      // Get the API URL from the .env file
      final apiUrl = dotenv.env['API_URL'];

      // Define the submit URL
      final submitUrl = '$apiUrl/applications';

      // Get the user inputs
      final username = _usernameController.text;
      final fistName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final address = _addressController.text;
      final phone = _phoneController.text;
      final birthday = _birthdayController.text;
      final gender = _selectedGender;
      final qualifications = _qualificationsController.text;
      final specialization = _specializationController.text;
      final workplace = _workplaceController.text;
      final consultationFee = _consultationFeeController.text;
      final availableDays = _selectedWeekdays.toList();
      debugPrint('Available Days: $availableDays');

      // Set the isLoading variable to true
      setState(() {
        isLoading = true;
      });

      // Make a POST request to the API
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'firstName': fistName,
          'lastName': lastName,
          'email': email,
          'address': address,
          'contactNo': phone,
          'dob': birthday,
          'gender': gender,
          'qualification': qualifications,
          'specialization': specialization,
          'workplace': workplace,
          'consultationFee': consultationFee,
          'availableDays': availableDays,
        }),
      );

      // Get the response body
      // final responseBody = json.decode(response.body);

      // Debug print the response status
      // debugPrint('status: ${response.statusCode}');
      // Debug print the response body
      // debugPrint('Response: $responseBody');

      if (response.statusCode == 201) {
        // Show a success message
        _showMessage('Profile submitted successfully');

        // Clear the user inputs
        _usernameController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _addressController.clear();
        _phoneController.clear();
        _birthdayController.clear();
        _qualificationsController.clear();
        _specializationController.clear();
        _workplaceController.clear();
        _consultationFeeController.clear();
        setState(() {
          _selectedGender = null;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PsychologistLoginScreen()),
        );
      } else {
        _showMessage('Failed to submit profile. Please try again.');
      }
    } catch (error) {
      _showMessage('An error occurred. Please try again');
    } finally {
      // Set the _isLoading variable to false
      setState(() {
        isLoading = false;
      });
    }
  }

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
                _firstNameController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              Text('FirstName', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your firt name',
                _lastNameController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'firstname is required.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              Text('LastName', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your last name',
                _usernameController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'lastname is required.';
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
              TextFormField(
                controller: _birthdayController,
                readOnly: true, // Prevents manual editing
                decoration: InputDecoration(
                  labelText: 'Enter your birthday',
                  suffixIcon:
                      Icon(Icons.calendar_today), // Adds a calendar icon
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900), // Earliest selectable date
                    lastDate: DateTime(2100), // Latest selectable date
                  );

                  if (pickedDate != null) {
                    // Format the date and update the controller
                    _birthdayController.text =
                        '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                  }
                },
                validator: (value) {
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
              Text('Available Days', style: _sectionTitleStyle()),
              _buildAvailableDatesButtons(),

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

              SizedBox(height: 10),
              Text('Workplace', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your workplace location',
                _workplaceController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Workplace location is required.';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),
              Text('Consultation Fee', style: _sectionTitleStyle()),
              _buildTextField(
                'Enter your consultation fee',
                _consultationFeeController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'consultation fee is required.';
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
                    _validateAndSaveProfile();
                    if (_formKey.currentState!.validate() &&
                        _validateAndSaveProfile()) {
                      _submit();
                      // // Process the form
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Profile saved successfully!'),
                      //   ),
                      // );
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

// State variable to track selected weekdays
  Set<String> _selectedWeekdays = {};

// Weekdays selection buttons
  Widget _buildAvailableDatesButtons() {
    // List of weekdays
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10, // Space between buttons horizontally
          runSpacing: 10, // Space between rows vertically
          children: weekdays.map((day) {
            bool isSelected = _selectedWeekdays.contains(day);
            return OutlinedButton(
              onPressed: () {
                setState(() {
                  if (isSelected) {
                    _selectedWeekdays.remove(day); // Deselect day
                  } else {
                    _selectedWeekdays.add(day); // Select day
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? Colors.blue[100]
                    : Colors.white, // Highlight if selected
                side: BorderSide(
                  color: Colors.black, // Black border for all buttons
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                day,
                style: TextStyle(color: Colors.black), // Text color
              ),
            );
          }).toList(),
        ),
        if (_selectedWeekdays.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Please select at least one weekday.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
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
