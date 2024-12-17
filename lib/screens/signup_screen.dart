import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nuranest/psychologist_screens/enroll_as_psychologist.dart';
import 'dart:convert';

import 'package:nuranest/screens/login_screen.dart';
import 'package:nuranest/utils/userValidators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;

// Create a global key that uniquely identifies the Form widget
  final _formKey = GlobalKey<FormState>();

// Define the text controllers for the input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

// Define the loading state
  bool _isLoading = false;

  Future<void> _register() async {
    try {
      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Define the register URL
      final registerUrl = '$apiUrl/auth/register';

      // Get the user input
      final username = usernameController.text;
      final email = emailController.text;
      final phone = phoneController.text;
      final password = passwordController.text;

      // set the _isLoading variable to true
      setState(() {
        _isLoading = true;
      });

      // Make a POST request to the register URL
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      // Check if the response status code is 200
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        _showMessage(
            '${responseData['message'] ?? 'Register successful. Welcome!'}');

        // If the form is valid, navigate to the LoginScreen
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));

        // Clear the text fields
        usernameController.clear();
        emailController.clear();
        phoneController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
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
  void dispose() {
    // Clean up the controller when the widget is disposed
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90), // Top margin

                const CircleAvatar(
                  radius: 52, // Profile image
                  backgroundImage: AssetImage('lib/assets/images/18.png'),
                ),

                const SizedBox(height: 20), // Space between image and title

                const Text(
                  "Oh You are New!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.43,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20), // Space between title and subtitle

                const Text(
                  "Let's create an account for you",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.43,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40), // Space between subtitle and fields

                // Name Field
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 245, 245),
                    prefixIcon: const Icon(Icons.person,
                        color: Color.fromRGBO(0, 0, 0, 0.5)),
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 17),
                  ),
                  validator: (value) {
                    if (!validateName(value)) {
                      return 'Please enter a valid name.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 245, 245),
                    prefixIcon: const Icon(Icons.email,
                        color: Color.fromRGBO(0, 0, 0, 0.5)),
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 17),
                  ),
                  validator: (value) {
                    if (!validateEmail(value)) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Phone Field
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 245, 245),
                    prefixIcon: const Icon(Icons.phone,
                        color: Color.fromRGBO(0, 0, 0, 0.5)),
                    hintText: 'Phone',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 17),
                  ),
                  validator: (value) {
                    if (!validatePhone(value)) {
                      return 'Please enter a valid phone number.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 245, 245),
                    prefixIcon: const Icon(Icons.lock,
                        color: Color.fromRGBO(0, 0, 0, 0.5)),
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 17),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (!validatePassword(value)) {
                      return 'Password should contain at least 8 characters, including a letter, a number, and a special character.';
                    }
                    return null;
                  },
                ),

                // const SizedBox(height: 10),
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Password should be comprised of at least 8 characters, with Lowercase letter, uppercase letter and any special character among (@,#,!,*,%).",
                //     style: TextStyle(
                //       fontFamily: 'Poppins',
                //       fontSize: 10,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.red,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 20),

                // Confirm Password Field
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 245, 245),
                    prefixIcon: const Icon(Icons.lock,
                        color: Color.fromRGBO(0, 0, 0, 0.5)),
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 17),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmText = !_obscureConfirmText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmText,
                  validator: (value) {
                    if (!validateConfirmPassword(passwordController.text,
                        confirmPasswordController.text)) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 50), // Space between fields and button

                // Create Account Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Call the _register method
                      _register();

                      // If the form is valid, navigate to the HomeScreen
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const LoginScreen()),
                      // );

                      // // Clear the text fields
                      // nameController.clear();
                      // emailController.clear();
                      // phoneController.clear();
                      // passwordController.clear();
                      // confirmPasswordController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: const Color.fromRGBO(239, 222, 214, 1),
                    minimumSize: const Size(360, 48),
                  ),
                  // child: const Text(
                  //   "Create and Log In",
                  //   style: TextStyle(
                  //     fontFamily: 'Poppins',
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w500,
                  //     letterSpacing: 0,
                  //     color: Colors.black,
                  //   ),
                  // ),

                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Create and Log In',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            color: Colors.black,
                          ),
                        ),
                ),

                const SizedBox(height: 20), // Space between button and login text

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 255,1),
                        ),
                      ),
                    ),
                  ],
                ),

                                const SizedBox(height: 20), // Space between button and login text


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

                const SizedBox(height: 20), // Space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
