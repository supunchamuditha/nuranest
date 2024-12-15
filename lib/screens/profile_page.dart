import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nuranest/psychologist_screens/enroll_as_psychologist.dart';
import 'package:nuranest/screens/payment_details.dart';
import 'package:nuranest/utils/appointmentValidators.dart';
import 'package:nuranest/utils/userValidators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Create a global key that uniquely identifies the Form widget
  final _formKey = GlobalKey<FormState>();

  // Variables to hold user information
  int? id = 0;
  String? username = '';
  String? firstName = '';
  String? lastName = '';
  String? userEmail = '';
  String? userPhone = '';
  String? userBirthDate = '';
  String? userGender = '';
  String? userAddress = '';

  // Define the _isLoading variable
  bool _isLoading = false;

  // Text controllers to hold profile information
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController birthDateController;
  late TextEditingController genderController;
  late TextEditingController addressController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    birthDateController = TextEditingController();
    genderController = TextEditingController();
    addressController = TextEditingController();

    _loadUserInfo();
  }

  // Method to toggle editing state
  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetails = prefs.getString('user');

    if (userDetails != null) {
      Map<String, dynamic> user = json.decode(userDetails);

      // print(userDetails);
      setState(() {
        id = user['id'] ?? '';
        username = user['username'] ?? '';
        userEmail = user['email'] ?? '';
        firstName = user['firstName'] ?? '';
        lastName = user['lastName'] ?? '';
        userGender = user['gender'] ?? '';
        userBirthDate = user['dob'] ?? '';
        userAddress = user['address'] ?? '';
        userPhone = user['contactNo'] ?? '';

        // Update TextEditingControllers
        usernameController.text = username!;
        emailController.text = userEmail!;
        phoneController.text = userPhone!;
        birthDateController.text = userBirthDate!;
        genderController.text = userGender!;
        addressController.text = userAddress!;
      });
    }
  }

  Future<void> _saveUserInfo() async {
    try {
      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Get the user token from the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Define the save URL
      final saveUrl = '$apiUrl/users/$id';

      // Set the _isLoading variable to true
      setState(() {
        _isLoading = true;
      });

      // Get the user input
      final username = usernameController.text;
      final email = emailController.text;
      final firstName = 'firstName';
      final lastName = 'lastName';
      final gender = genderController.text;
      final dob = birthDateController.text;
      final address = addressController.text;
      final contactNo = phoneController.text;

      // print(
      //     'Username: $username, Email: $email, First Name: $firstName, Last Name: $lastName, Gender: $gender, DOB: $dob, Address: $address, Contact No: $contactNo');
      // Make a PUT request to the save URL
      final response = await http.put(Uri.parse(saveUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'username': username,
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'gender': gender,
            'dob': dob,
            'address': address,
            'contactNo': contactNo,
          }));

      // Check if the response is successful
      // print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _showMessage(
            '${responseData['message'] ?? 'User information saved successfully'}');

        // Save the user information to the shared preferences
        await prefs.setString('user', jsonEncode(responseData['user']));

        //
        // String? userDetails = prefs.getString('user');
        // print(userDetails);
      } else {
        // If the response status code is not 200, show an error message
        final errorData = jsonDecode(response.body);
        _showMessage(
            '${errorData['message'] ?? 'An error occurred. Please try again'}');
      }
    } catch (error) {
      _showMessage('An error occurred. Please try again');
    } finally {
      // Set the _isLoading variable to false
      setState(() {
        _isLoading = false;
      });
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
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Same background color
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), // Space from top

                  const CircleAvatar(
                    radius: 52, // Profile image
                    backgroundImage: AssetImage('lib/assets/images/18.png'),
                  ),

                  const SizedBox(height: 20), // Space

                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: usernameController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Username',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.43,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        prefixIcon: const Icon(Icons.person,
                            color: Color.fromRGBO(0, 0, 0, 0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(31.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 17),
                      ),
                      validator: (value) {
                        if (!validateUsername(value)) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email TextFormField
                  GestureDetector(
                    onDoubleTap: toggleEditMode,
                    child: TextFormField(
                      controller: emailController,
                      enabled: isEditing,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.43,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        prefixIcon: const Icon(Icons.email,
                            color: Color.fromRGBO(0, 0, 0, 0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(31.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 17),
                      ),
                      validator: (value) {
                        if (!validateEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phone TextFormField
                  GestureDetector(
                    onDoubleTap: toggleEditMode,
                    child: TextFormField(
                      controller: phoneController,
                      enabled: isEditing,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.43,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        prefixIcon: const Icon(Icons.phone,
                            color: Color.fromRGBO(0, 0, 0, 0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(31.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 17),
                      ),
                      validator: (value) {
                        if (!validatePhone(value)) {
                          return 'Please enter a valid phone number.';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Birthdate TextFormField with label
                  GestureDetector(
                    onDoubleTap: toggleEditMode,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            ' Birth date',
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: birthDateController,
                            enabled: isEditing,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Birthdate',
                              hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.43,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(31.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 17),
                            ),
                            validator: (value) {
                              // print("object");
                              if (!validateDob(value)) {
                                return 'Please enter a valid date of birth';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Gender TextFormField with label
                  GestureDetector(
                    onDoubleTap: toggleEditMode,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            ' Gender',
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: genderController,
                            enabled: isEditing,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Gender',
                              hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.43,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(31.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 17),
                            ),
                            validator: (value) {
                              if (!validateGender(value)) {
                                return 'Please select gender';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Address TextFormField with label
                  GestureDetector(
                    onDoubleTap: toggleEditMode,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            ' Address',
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: addressController,
                            enabled: isEditing,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Address',
                              hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.43,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(31.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 17),
                            ),
                            validator: (value) {
                              if (!validateAddress(value)) {
                                return 'Please enter a valid address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save Button - wider than previous version
                  ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          if (_formKey.currentState!.validate()) {
                            // Save user information
                            _saveUserInfo();
                            //   // Save logic here
                            //   setState(() {
                            //     isEditing = false; // Stop editing
                            //   });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20), // Make it wider
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor:const Color.fromARGB(255, 239, 222, 214),
                        minimumSize: const Size(360, 48),
                      ),
                      // child: const Text(
                      // 'Save',
                      // style: TextStyle(
                      //   fontFamily: 'Poppins',
                      //   fontSize: 14,
                      //   fontWeight: FontWeight.w500,
                      //   letterSpacing: 1,
                      //   color: Colors.black,
                      // ),
                      // ),

                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow
                          .ellipsis, 
                      )),

                  const SizedBox(height: 10), // Space before new buttons

                  const Text(
                    'Double tap to change details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Color.fromARGB(90, 0, 0, 0),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Enroll as Psychologist Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EnrollAsPsychologistScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 239, 222, 214),
                            width: 1), // Border color
                      ),
                      backgroundColor: const Color.fromARGB(
                          255, 255, 255, 255), // Remove background color
                          minimumSize: const Size(360, 48),
                    ),
                    child: const Text(
                      'Enroll as Psychologist',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Ensure the text is in one line
                    ),
                  ),

                  const SizedBox(height: 20),

                  // View Payment History Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentDetailsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 239, 222, 214),
                            width: 1), // Border color
                      ),
                      backgroundColor: const Color.fromARGB(
                          255, 255, 255, 255), // Remove background color
                          minimumSize: const Size(360, 48),
                    ),
                    child: const Text(
                      'View Payment History',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Ensure the text is in one line
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )),
      ),
    );
  }
}
