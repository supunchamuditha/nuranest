import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Text controllers to hold profile information
  TextEditingController nameController = TextEditingController(text: 'Supun Madushanka');
  TextEditingController emailController = TextEditingController(text: 'supun1221@gmail.com');
  TextEditingController phoneController = TextEditingController(text: '0112345678');
  TextEditingController birthDateController = TextEditingController(text: '2002-05-06');
  TextEditingController genderController = TextEditingController(text: 'Add');
  TextEditingController addressController = TextEditingController(text: 'Add your address');

  bool isEditing = false;

  // Method to toggle editing state
  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 240, 255), // Same background color
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 239, 222, 214),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Space from top

              const CircleAvatar(
                radius: 52, // Profile image
                backgroundImage: AssetImage('lib/assets/images/18.png'),
              ),

              const SizedBox(height: 20), // Space

              // Name TextField
              GestureDetector(
                onDoubleTap: toggleEditMode, // Enables editing on double-tap
                child: TextField(
                  controller: nameController,
                  enabled: isEditing, // Enable only in edit mode
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Email TextField
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: TextField(
                  controller: emailController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.email, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Phone TextField
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: TextField(
                  controller: phoneController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.phone, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Birthdate TextField
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: TextField(
                  controller: birthDateController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.cake, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Gender TextField
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: TextField(
                  controller: genderController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person_outline, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Address TextField
              GestureDetector(
                onDoubleTap: toggleEditMode,
                child: TextField(
                  controller: addressController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.location_on, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    // Save logic here
                    setState(() {
                      isEditing = false; // Stop editing
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 98),
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
            ],
          ),
        ),
      ),
    );
  }
}
