import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nuranest/psychologist_screens/psychologist_login_screen.dart';
import 'dart:convert';
import 'package:nuranest/screens/signup_screen.dart';
import 'package:nuranest/screens/user_home.dart';
import 'package:nuranest/utils/userValidators.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; 
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); 
  }

  
  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? user = prefs.getString('user');

    if (token != null && user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _login() async {
    try {
      final apiUrl = dotenv.env['API_URL'];
      final loginUrl = '$apiUrl/auth/login';
      final email = emailController.text;
      final password = passwordController.text;

      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _showMessage(
            '${responseData['message'] ?? 'Login successful. Welcome!'}');

        // Extract and print the token from the response headers
        final token = response.headers['set-cookie']
            ?.split(';')
            .firstWhere((cookie) => cookie.startsWith('accessToken='))
            .split('=')[1];

        //Store user data in local storage
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(responseData['user']));
        await prefs.setString('token', token!);
        // If the form is valid, navigate to the HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

        // Clear the text fields
        emailController.clear();
        passwordController.clear();
        
      } else {
        final errorData = jsonDecode(response.body);
        _showMessage(errorData['message'] ?? 'Login failed. Please try again.');
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Set background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100), // Top margin

                const CircleAvatar(
                  radius: 52, // Set image dimensions here
                  backgroundImage: AssetImage('lib/assets/images/18.png'),
                ),

                const SizedBox(
                    height: 20), // Space between image and welcome text

                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.43,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(
                    height: 10), // Space between welcome text and subtitle

                const Text(
                  "Log into your existing account of NuraNest",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.43,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(
                    height: 20), // Space between subtitle and email field

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 245, 245),
                    prefixIcon: const Icon(Icons.email,
                        size: 16, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    hintText: 'Email',
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
                        vertical: 13, horizontal: 17),
                  ),
                  validator: (value) {
                    if (!validateEmail(value)) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                    height: 20), // Space between email and password fields

                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 245, 245),
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 16,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    hintText: 'Password',
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
                        vertical: 12, horizontal: 20),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; // Toggle password visibility
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (!validatePassword(value)) {
                      return 'Password must be at least 8 characters.';
                    }
                    return null;
                  }, // Password input field
                ),

                const SizedBox(
                    height:
                        15), // Space between password field and forgot password

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "forgot password?",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(33, 16, 191, 1),
                    ),
                  ),
                ),

                const SizedBox(
                    height:
                        60), // Space between forgot password and login button

                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                        // If the form is valid, navigate to the HomeScreen
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => HomeScreen()),
                        // );

                        // // Clear the text fields
                        // emailController.clear();
                        // passwordController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color.fromRGBO(239, 222, 214, 1),
                      minimumSize: const Size(360, 48),
                    ),
                    // child: const Text(
                    //   "Log in",
                    //   style: TextStyle(
                    //     fontFamily: 'Poppins',
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //     letterSpacing: 1,
                    //     color: Colors.black,
                    //   ),
                    // ),

                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Log in",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              color: Colors.black,
                            ),
                          )),

                const SizedBox(height: 20),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.43,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.43,
                          color: Color.fromRGBO(33, 16, 191, 1),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40), // Space at the bottom                
                
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Are you a Psychologist",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.5,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PsychologistLoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: const Color.fromRGBO(193, 207, 212, 1),
                    minimumSize: const Size(360, 48),
                  ),
                  child: const Text(
                    "Log In as a Psychologist",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
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
