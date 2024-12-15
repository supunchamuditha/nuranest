import 'package:flutter/material.dart';
import 'package:nuranest/utils/appointmentValidators.dart';
import 'package:nuranest/utils/userValidators.dart'; // Import the userValidators file
import 'package:shared_preferences/shared_preferences.dart'; // Import the shared_preferences library
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the flutter_dotenv library

class PsychologistProfilePage extends StatefulWidget {
  const PsychologistProfilePage({super.key});

  @override
  _PsychologistProfilePageState createState() =>
      _PsychologistProfilePageState();
}

class _PsychologistProfilePageState extends State<PsychologistProfilePage> {
  // Create a global key that uniquely identifies the form widget
  final _formKey = GlobalKey<FormState>();

  //variables to hold user information
  int? getId = 0;
  int? getDocId = 0;
  String? getUsername = '';
  String? getFistName = '';
  String? getLastName = '';
  String? getEmail = '';
  String? getPhone = '';
  String? getBirthDate = '';
  String? getGender = '';
  String? getAddress = '';
  String? getHospital = '';
  String? getQualification = '';
  String? getSpecial = '';

  // Define the _isLoading variable
  bool _isLoading = false;

  // Text controllers to hold profile information
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController birthDateController;
  late TextEditingController genderController;
  late TextEditingController addressController;
  late TextEditingController hospitalController;
  late TextEditingController qualificationController;
  late TextEditingController specialController;
  // TextEditingController usernameController =
  //     TextEditingController(text: 'Shanez Fernando');
  // TextEditingController emailController =
  //     TextEditingController(text: 'Shanez7@gmail.com');
  // TextEditingController phoneController =
  //     TextEditingController(text: '0112345678');
  // TextEditingController birthDateController =
  //     TextEditingController(text: '1988-05-06');
  // TextEditingController genderController = TextEditingController(text: 'Add');
  // TextEditingController addressController =
  //     TextEditingController(text: 'Add your address');
  // TextEditingController hospitalController =
  //     TextEditingController(text: 'Add your hospital');
  // TextEditingController qualificationController =
  //     TextEditingController(text: 'Add your qualifications');
  // TextEditingController specialController =
  //     TextEditingController(text: 'Add your specialized categories');

  // Define the _isEditing variable
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    birthDateController = TextEditingController();
    genderController = TextEditingController();
    addressController = TextEditingController();
    hospitalController = TextEditingController();
    qualificationController = TextEditingController();
    specialController = TextEditingController();

    _loadUserInfo();
  }

  // Method to load user information
  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetails = prefs.getString('user');
    String? doctorDetails = prefs.getString('doctor');

    if (userDetails != null) {
      Map<String, dynamic> user = json.decode(userDetails);

      // print(userDetails);
      setState(() {
        getId = user['id'] ?? '';
        getUsername = user['username'] ?? '';
        getEmail = user['email'] ?? '';
        getFistName = user['firstName'] ?? '';
        getLastName = user['lastName'] ?? '';
        getGender = user['gender'] ?? '';
        getBirthDate = user['dob'] ?? '';
        getAddress = user['address'] ?? '';
        getPhone = user['contactNo'] ?? '';

        // Update TextEditingControllers
        usernameController.text = getUsername!;
        emailController.text = getEmail!;
        phoneController.text = getPhone!;
        birthDateController.text = getBirthDate!;
        genderController.text = getGender!;
        addressController.text = getAddress!;
      });
    }

    if (doctorDetails != null) {
      Map<String, dynamic> doctor = json.decode(doctorDetails);

      setState(() {
        getDocId = doctor['id'] ?? '';
        getHospital = doctor['workplace'] ?? '';
        getQualification = doctor['qualification'] ?? '';
        getSpecial = doctor['specialization'] ?? '';

        // Update TextEditingControllers
        hospitalController.text = getHospital!;
        qualificationController.text = getQualification!;
        specialController.text = getSpecial!;
      });
    }
  }

  // Define the _showMessage method
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  //
  Future<void> _saveUserInfo() async {
    try {
      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Get the user token from the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Define the save URL
      final saveUrl_1 = '$apiUrl/users/$getId';
      final saveUrl_2 = '$apiUrl/doctors/$getDocId';

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
      final hospital = hospitalController.text;
      final qualification = qualificationController.text;
      final special = specialController.text;
      final consultationFee = 0;
      final availableDays = ["MBBS", "MD", "Psychiatry"];

      // print(
      // 'Username: $username, Email: $email, First Name: $firstName, Last Name: $lastName, Gender: $gender, DOB: $dob, Address: $address, Contact No: $contactNo, Hospital: $hospital, Qualification: $qualification, Specialized: $special'); // Print the user input

      // Make a PUT request to the save URL
      final responseUser = await http.put(Uri.parse(saveUrl_1),
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

      final responsDoctor = await http.put(Uri.parse(saveUrl_2),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userId': getId,
            'workplace': hospital,
            'qualification': qualification,
            'specialization': special,
            'consultationFee': consultationFee,
            'availableDays': availableDays,
          }));

      // Check if the response is successful
      // print(responseUser.statusCode);
      // print(responsDoctor.statusCode);

      if (responseUser.statusCode == 200 && responsDoctor.statusCode == 200) {
        // Decode the response data
        final responseUserData = json.decode(responseUser.body);
        final responseDoctorData = json.decode(responsDoctor.body);

        _showMessage('User information saved successfully');

        // Save the user information to the shared preferences
        await prefs.setString('user', jsonEncode(responseUserData['user']));
        await prefs.setString(
            'doctor', jsonEncode(responseDoctorData['doctor']));

        // Print the user and doctor details
        // String? userDetails = prefs.getString('user');
        // print(userDetails);
        // String? doctorDetails = prefs.getString('doctor');
        // print(doctorDetails);
      } else {
        _showMessage('An error occurred. Please try again');
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

  // Method to toggle editing state
  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 245, 240, 255), // Same background color
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 245, 240, 255),
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

              // Name TextFormField
              GestureDetector(
                onDoubleTap: toggleEditMode, // Enables editing on double-tap
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
                    hintText: 'Phone',
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
                          hintText: 'YYYY-MM-DD',
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

              // Hospital TextFormField with label
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' Hospital',
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
                        controller: hospitalController,
                        enabled: isEditing,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Hospital',
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
                            if (!validateHospital(value)) {
                              return 'Please enter a valid hospital';
                            }
                            return null;
                          },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Qualification TextFormField with label
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' Qualification',
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
                        controller: qualificationController,
                        enabled: isEditing,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Qualification',
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
                          if (!validateQualification(value)) {
                            return 'Please enter a valid qualification';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Special in TextFormField with label
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' Special in',
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
                        controller: specialController,
                        enabled: isEditing,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Special in',
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
                          if (!validateSpecial(value)) {
                            return 'Please enter a valid special category';
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
                      // Save the user information
                      _saveUserInfo();

                      // Disable editing
                      setState(() {
                        isEditing = false; // Stop editing
                      });
                    }
                  }
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

              const SizedBox(height: 20),

              // View Payment History Button
              ElevatedButton(
                onPressed: () {
                  // Add action for viewing payment history
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 239, 222, 214),
                        width: 1), // Border color
                  ),
                  backgroundColor: const Color.fromARGB(
                      255, 245, 240, 255), // Remove background color
                ),
                child: const Text(
                  'View Payment History',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: Colors.black,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Ensure the text is in one line
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }
}
