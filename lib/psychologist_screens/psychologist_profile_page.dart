import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:nuranest/psychologist_screens/enroll_as_psychologist.dart';
import 'package:nuranest/screens/get_started_screen.dart';
// import 'package:nuranest/screens/login_screen.dart';
import 'package:nuranest/screens/payment_details.dart';
// import 'package:nuranest/utils/appointmentValidators.dart';
import 'package:nuranest/utils/userValidators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library
import 'package:nuranest/utils/storage_helper.dart'; // Import the storage_helper.dart file
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder library
import 'package:intl/intl.dart'; // Import the intl library

Future<void> logout(BuildContext context) async {
  // Access SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Clear specific flags or all preferences
  await prefs
      .clear(); // Clears all preferences (optional: clear only specific keys)

  // Navigate to GetStartedScreen and clear the navigation stack
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const GetStartedScreen()),
    (route) => false,
  );
}

class PsychologistProfilePage extends StatefulWidget {
  const PsychologistProfilePage({super.key});

  @override
  _PsychologistProfilePageState createState() =>
      _PsychologistProfilePageState();
}

class _PsychologistProfilePageState extends State<PsychologistProfilePage> {
  // Create a global key that uniquely identifies the Form widget
  final _formKey = GlobalKey<FormState>();

  // Variables to hold user information
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
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController birthDateController;
  late TextEditingController genderController;
  late TextEditingController addressController;
  late TextEditingController qalificationController;
  late TextEditingController specializationController;
  late TextEditingController workplaceController;
  late TextEditingController consultationFeeController;

  bool isEditing = false;

  // Store doctor ID
  int? doctorId;

  List<int> selectedDays = [];

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    birthDateController = TextEditingController();
    genderController = TextEditingController();
    addressController = TextEditingController();
    qalificationController = TextEditingController();
    specializationController = TextEditingController();
    workplaceController = TextEditingController();
    consultationFeeController = TextEditingController();

    _loadUserInfo();
    _loadDoctorInfo();
  }

  // Method to toggle editing state
  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _loadUserInfo() async {
    try {
      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Get the user's token from SharedPreferences
      String? token = await getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Extract the user ID (or any other field you need)
      int? userId = decodedToken['id'];

      // Define the user URL
      final userUrl = '$apiUrl/users/$userId';

      // Set the _isLoading variable to true
      setState(() {
        _isLoading = true;
      });

      // Make a GET request to the user URL
      final response = await http.get(Uri.parse(userUrl), headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      });

      final resAppData = json.decode(response.body);

      // Check if the response is successful
      if (response.statusCode == 200) {
        final userDetails = resAppData['user'];

        String? dob = userDetails['dob'];
        dob = DateFormat('yyyy-MM-dd').format(DateTime.parse(dob!));

        // Set the user information to the text controllers
        setState(() {
          usernameController.text = userDetails['username'];
          firstnameController.text = userDetails['firstName'];
          lastnameController.text = userDetails['lastName'];
          emailController.text = userDetails['email'];
          phoneController.text = userDetails['contactNo'];
          birthDateController.text = dob!;
          genderController.text = userDetails['gender'];
          addressController.text = userDetails['address'];
        });
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

  Future<void> _loadDoctorInfo() async {
    try {
      // Get the user's token from SharedPreferences
      String? token = await getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Extract the user ID (or any other field you need)
      int? userId = decodedToken['id'];

      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Define the endpoint
      final endpoint = '$apiUrl/doctors/user/$userId';

      // Make a GET request to the endpoint
      final response = await http.get(Uri.parse(endpoint), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      // Decode the response
      final doctorData = json.decode(response.body);

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Get the doctor information
        final doctorDetails = doctorData['doctor'];

        // debugPrint('doctorDetails: $doctorDetails');

        // Get the selected days
        List<String> selectedDayas =
            doctorDetails['availableDays'].cast<String>();
        List<int> selectedDayIndices = getDayIndices(selectedDayas);
        // debugPrint('$selectedDayIndices');

        // Set the doctor information to the text controllers
        setState(() {
          qalificationController.text = doctorDetails['qualification'];
          specializationController.text = doctorDetails['specialization'];
          workplaceController.text = doctorDetails['workplace'];
          consultationFeeController.text = doctorDetails['consultationFee'];
          doctorId = doctorDetails['id'];
          selectedDays = selectedDayIndices;
        });
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

  Future<void> _save() async {
    if (!validateSelectedDays(selectedDays)) {
      _showMessage("Please select at least two days.");
      return;
    }

    _saveUserInfo();
    _saveDoctorInfo();
  }

  Future<void> _saveUserInfo() async {
    try {
      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Get the user token from the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get the user's token from SharedPreferences
      String? token = await getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Extract the user ID (or any other field you need)
      int? id = decodedToken['id'];

      // Define the save URL
      final saveUrl = '$apiUrl/users/$id';

      // Set the _isLoading variable to true
      setState(() {
        _isLoading = true;
      });

      // Get the user input
      final username = usernameController.text;
      final email = emailController.text;
      final firstName = firstnameController.text;
      final lastName = lastnameController.text;
      final gender = genderController.text;
      final dob = birthDateController.text;
      final address = addressController.text;
      final contactNo = phoneController.text;

      // debugPrint(
      // 'Username: $username, Email: $email, First Name: $firstName, Last Name: $lastName, Gender: $gender, DOB: $dob, Address: $address, Contact No: $contactNo');

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

      // debugPrint('response: $response');

      // Check if the response is successful
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

  Future<void> _saveDoctorInfo() async {
    try {
      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Get the user token from the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get the user's token from SharedPreferences
      String? token = await getToken();

      // Extract the doctor ID (or any other field you need)
      int? id = doctorId;

      // Define the save URL
      final saveUrl = '$apiUrl/doctors/$id';

      // Set the _isLoading variable to true
      setState(() {
        _isLoading = true;
      });

      // Get the user input
      final qualification = qalificationController.text;
      final specialization = specializationController.text;
      final workplace = workplaceController.text;
      final consultationFee = consultationFeeController.text;
      final availableDays = getSelectedDays();

      // Log the doctor information
      // debugPrint(
      // 'Qualification: $qualification, Specialization: $specialization, Workplace: $workplace, Consultation Fee: $consultationFee');
      // debugPrint('availableDays: $availableDays');

      // Make a PUT request to the save URL
      final response = await http.put(Uri.parse(saveUrl),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'qualification': qualification,
            'specialization': specialization,
            'workplace': workplace,
            'consultationFee': consultationFee,
            'availableDays': availableDays,
          }));

      // Check if the response is successful
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _showMessage(
            '${responseData['message'] ?? 'Doctor information saved successfully'}');

        // Save the doctor information to the shared preferences
        await prefs.setString('doctor', jsonEncode(responseData['doctor']));
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

  void toggleDaySelection(int dayIndex) {
    setState(() {
      if (selectedDays.contains(dayIndex)) {
        selectedDays.remove(dayIndex);
      } else {
        selectedDays.add(dayIndex);
      }
    });
  }

  List<String> getSelectedDays() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return selectedDays.map((index) => days[index]).toList();
  }

  List<int> getDayIndices(List<String> selectedDayNames) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return selectedDayNames.map((day) => days.indexOf(day)).toList();
  }

  void toggleAllDays(bool selectAll) {
    setState(() {
      if (selectAll) {
        selectedDays = List.generate(7, (index) => index); // Select all days
      } else {
        selectedDays.clear(); // Deselect all days
      }
    });
  }

  bool validateSelectedDays(List<int> selectedDays) {
    return selectedDays.length >= 2;
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
                    radius: 80, // Profile image
                    backgroundImage: AssetImage('lib/assets/images/18.png'),
                  ),

                  const SizedBox(height: 30), // Space

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Username',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: usernameController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
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

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'First Name',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: firstnameController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
                        hintText: 'First Name',
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
                        if (!validateName(value)) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Last Name',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: lastnameController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
                        hintText: 'Last Name',
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
                        if (!validateName(value)) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'E-mail',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Email TextFormField
                  GestureDetector(
                    onDoubleTap: toggleEditMode,
                    child: TextFormField(
                      controller: emailController,
                      enabled: isEditing,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
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

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Address',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: lastnameController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
                        hintText: 'Address',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.43,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        prefixIcon: const Icon(Icons.location_on,
                            color: Color.fromRGBO(0, 0, 0, 0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(31.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 17),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phone number label
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          ' Phone number',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Phone TextFormField
                  GestureDetector(
                    onDoubleTap: toggleEditMode,
                    child: TextFormField(
                      controller: phoneController,
                      enabled: isEditing,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
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
                            readOnly: true, // Disable keyboard input
                            onTap: isEditing
                                ? () async {
                                    // Show Date Picker
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );

                                    if (pickedDate != null) {
                                      // Update the controller with selected date
                                      setState(() {
                                        birthDateController.text =
                                            "${pickedDate.toLocal()}"
                                                .split(' ')[0];
                                      });
                                    }
                                  }
                                : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 255, 249, 249),
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

                  // Gender DropdownButtonFormField with label
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
                          child: DropdownButtonFormField<String>(
                            value: genderController.text.isNotEmpty
                                ? genderController.text
                                : null, // Set initial value
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 255, 249, 249),
                              hintText: 'Select Gender',
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
                            items: const [
                              DropdownMenuItem(
                                value: 'Male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'Female',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other'),
                              ),
                            ],
                            onChanged: isEditing
                                ? (value) {
                                    setState(() {
                                      genderController.text = value ?? '';
                                    });
                                  }
                                : null, // Disable dropdown if not in edit mode
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qalification',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Qalification TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: qalificationController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
                        hintText: 'Qalification',
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
                        if (!validateName(value)) {
                          return 'Please enter a qalification';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Specialization',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: specializationController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
                        hintText: 'Specialization',
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
                        if (!validateName(value)) {
                          return 'Please enter a specialization';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Workplace',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: workplaceController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
                        hintText: 'Workplace',
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
                        if (!validateName(value)) {
                          return 'Please enter a workplace';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Consultation Fee',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Username TextFormField
                  GestureDetector(
                    onDoubleTap:
                        toggleEditMode, // Enables editing on double-tap
                    child: TextFormField(
                      controller: consultationFeeController,
                      enabled: isEditing, // Enable only in edit mode
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 249, 249),
                        hintText: 'Consultation Fee',
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
                        if (!validateName(value)) {
                          return 'Please enter a consultation fee';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildAvailableDaysCard(context),

                  const SizedBox(height: 20),

                  // Save Button - wider than previous version
                  ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          if (_formKey.currentState!.validate()) {
                            // Save logic here
                            _save();
                            
                            // Save user information
                            // _saveUserInfo();
                            // Save doctor information
                            // _saveDoctorInfo();
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
                        backgroundColor:
                            const Color.fromARGB(255, 239, 222, 214),
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
                              overflow: TextOverflow.ellipsis,
                            )),

                  const SizedBox(height: 10), // Space before new buttons

                  const Text(
                    'Double tap to change details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: Color.fromARGB(90, 0, 0, 0),
                    ),
                  ),

                  const SizedBox(height: 10),

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

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Confirm Logout',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to logout?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  await logout(
                                      context); // Call the logout function
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 239, 222, 214),
                          width: 1,
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 248, 220, 220),
                      minimumSize: const Size(360, 48),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildAvailableDaysCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available days',
          style: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            // First row (Mon, Tue, Wed, Thu)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu'];
                return buildDayChip(days[index], index);
              }),
            ),
            const SizedBox(height: 10),
            // Second row (Fri, Sat, Sun)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final days = ['Fri', 'Sat', 'Sun'];
                return buildDayChip(days[index], index + 4);
              }),
            ),
            const SizedBox(height: 10),
            // Select All or Deselect All button
            ElevatedButton(
              onPressed: () {
                toggleAllDays(selectedDays.length != 7); // Select/deselect all
              },
              child: Text(
                  selectedDays.length == 7 ? "Deselect All" : "Select All"),
            ),
            // Display selected days
            const SizedBox(height: 10),
            Text(
              "Selected Days: ${getSelectedDays().join(', ')}",
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDayChip(String day, int index) {
    return GestureDetector(
      onTap: () => toggleDaySelection(index),
      child: Container(
        decoration: BoxDecoration(
          color: selectedDays.contains(index)
              ? const Color.fromARGB(255, 229, 209, 183)
              : const Color.fromARGB(255, 255, 249, 249),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: selectedDays.contains(index)
                ? const Color.fromARGB(255, 229, 209, 183)
                : const Color.fromRGBO(0, 0, 0, 0.1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Text(
          day,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selectedDays.contains(index)
                ? Colors.black
                : const Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ),
      ),
    );
  }
}
