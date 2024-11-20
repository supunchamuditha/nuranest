import 'package:flutter/material.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    nameController.dispose();
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
          const Color.fromARGB(255, 245, 240, 255), // Background color
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
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.43,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10), // Space between title and subtitle

                const Text(
                  "Let's create an account for you",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.43,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20), // Space between subtitle and fields

                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person,
                        color: Color.fromRGBO(0, 0, 0, 0.5)),
                    hintText: 'Name',
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
                  },
                ),

                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                  },
                ),

                const SizedBox(height: 20),

                // Phone Field
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                  },
                ),

                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    fillColor: Colors.white,
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
                  },
                ),

                const SizedBox(height: 50), // Space between fields and button

                // Create Account Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, navigate to the HomeScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );

                      // Clear the text fields
                      nameController.clear();
                      emailController.clear();
                      phoneController.clear();
                      passwordController.clear();
                      confirmPasswordController.clear();
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
                  child: const Text(
                    "Create and Log In",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 20), // Space between button and login text

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
