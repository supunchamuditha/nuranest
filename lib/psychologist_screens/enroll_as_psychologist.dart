import 'package:flutter/material.dart';
import 'package:nuranest/psychologist_screens/after_request_profile.dart';
import 'package:nuranest/utils/storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the SharedPreferences library
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder library
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv library

class EnrollAsPsychologistScreen extends StatefulWidget {
  const EnrollAsPsychologistScreen({super.key});

  @override
  _EnrollAsPsychologistScreenState createState() =>
      _EnrollAsPsychologistScreenState();
}

class _EnrollAsPsychologistScreenState
    extends State<EnrollAsPsychologistScreen> {
  // Create a global key that uniquely identifies the Form widget
  // final _formKey = GlobalKey<FormState>();

  // Variables to hold user information
  int? userId;

  // Define the _isLoading variable
  bool isLoading = false;

  // Define the Text Field Controllers
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController qualificationsController =
      TextEditingController();
  final TextEditingController specialController = TextEditingController();
  final TextEditingController verificationController = TextEditingController();

  // Define the _submitForm function
  void _submitForm() async {
    try {
      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Get the user's token from SharedPreferences
      String? token = await getToken();

      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      // Get the user's ID from the token
      userId = decodedToken['id'];

      // Define the register URL
      final url = '$apiUrl/doctors/';

      // Show loading indicator
      setState(() {
        isLoading = true;
      });

      // Get user inputs
      final hospital = hospitalController.text;
      final qualifications = qualificationsController.text;
      final special = specialController.text;

      debugPrint('Hospital: $hospital');
      debugPrint('Qualifications: $qualifications');
      debugPrint('Special: $special');

      // Hide loading indicator
      setState(() {
        isLoading = false;
      });

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': userId,
            'workplace': hospital,
            'qualification': qualifications,
            'specialization': special,
            // 'verification': verificationController.text,
          }));

      // Check if the response is successful
      print(response.body);
      print(response.statusCode);
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // Define the _showMessage method
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile Image
              const CircleAvatar(
                radius: 52,
                backgroundImage:
                    AssetImage('lib/assets/images/psychologist_avatar.png'),
              ),

              const SizedBox(height: 20),

              // Input Fields
              _buildTextField('Hospital', 'Add Hospital', hospitalController),
              const SizedBox(height: 20),
              _buildTextField('Qualifications', 'Add Qualifications',
                  qualificationsController),
              const SizedBox(height: 20),
              _buildTextField(
                  'Special', 'Anything special to say', specialController),
              const SizedBox(height: 20),

              // Upload Verification Document
              _buildTextField(
                  'Verification Document', 'UPLOAD', verificationController,
                  isUpload: true),

              const SizedBox(height: 30),

              // Buttons

              ElevatedButton(
                onPressed: () {
                  _submitForm();

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const AfterRequestProfile()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 150), // Make it wider
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromARGB(255, 239, 222, 214),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AfterRequestProfile()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 150), // Make it wider
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 146, 146),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "You request will be reviewed by our team and you will be notified once it is approved.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController $controller,
      {bool isUpload = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          readOnly: isUpload,
          controller: $controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ],
    );
  }
}
