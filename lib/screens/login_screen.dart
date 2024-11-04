import 'package:flutter/material.dart';
import 'package:nuranest/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Define the _obscureText variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 245, 240, 255), // Set background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
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
                "Log into your existing account of <app name>",
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

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                ),
              ),

              const SizedBox(
                  height: 20), // Space between email and password fields

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                obscureText: _obscureText, // Password input field
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
                    color: Color.fromRGBO(150, 139, 255, 1),
                  ),
                ),
              ),

              const SizedBox(
                  height: 60), // Space between forgot password and login button

              ElevatedButton(
                onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromRGBO(239, 222, 214, 1),
                  minimumSize: const Size(360, 48),
                ),
                child: const Text(
                  "Log in",
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
              // Space between login button and connect with text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Or connect with,",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.43,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromRGBO(148, 249, 194, 1),
                  minimumSize: const Size(360, 48),
                ),
                child: const Text(
                  "Google",
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

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color.fromRGBO(193, 207, 212, 1),
                  minimumSize: const Size(360, 48),
                ),
                child: const Text(
                  "Facebook",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(
                  height: 80), // Space between buttons and sign up text

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.43,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.43,
                        color: Color.fromRGBO(150, 139, 255, 1),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20), // Space at the bottom
              
            ],
          ),
        ),
      ),
    );
  }
}
