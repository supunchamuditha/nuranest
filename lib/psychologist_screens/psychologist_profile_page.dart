import 'package:flutter/material.dart';
import 'package:nuranest/psychologist_screens/enroll_as_psychologist.dart';

class PsychologistProfilePage extends StatefulWidget {
  const PsychologistProfilePage({super.key});

  @override
  _PsychologistProfilePageState createState() => _PsychologistProfilePageState();
}

class _PsychologistProfilePageState extends State<PsychologistProfilePage> {
  // Text controllers to hold profile information
  TextEditingController nameController = TextEditingController(text: 'Shanez Fernando');
  TextEditingController emailController = TextEditingController(text: 'Shanez7@gmail.com');
  TextEditingController phoneController = TextEditingController(text: '0112345678');
  TextEditingController birthDateController = TextEditingController(text: '1988-05-06');
  TextEditingController genderController = TextEditingController(text: 'Add');
  TextEditingController addressController = TextEditingController(text: 'Add your address');
  TextEditingController hospitalController = TextEditingController(text: 'Add your hospital');
  TextEditingController qualificationController = TextEditingController(text: 'Add your qualifications');
  TextEditingController specialController = TextEditingController(text: 'Add your specialized categories');

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
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 245, 240, 255),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                  ),
                ),
              ),

              const SizedBox(height: 20),

                // Birthdate TextField with label
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
                        child: TextField(
                          controller: birthDateController,
                          enabled: isEditing,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(31.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Gender TextField with label
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
                        child: TextField(
                          controller: genderController,
                          enabled: isEditing,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(31.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Address TextField with label
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
                        child: TextField(
                          controller: addressController,
                          enabled: isEditing,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(31.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 20),

                // Hospital TextField with label
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
                        child: TextField(
                          controller: hospitalController,
                          enabled: isEditing,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(31.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Qualification TextField with label
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
                        child: TextField(
                          controller: qualificationController,
                          enabled: isEditing,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(31.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Special in TextField with label
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
                        child: TextField(
                          controller: specialController,
                          enabled: isEditing,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(31.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                          ),
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
                    // Save logic here
                    setState(() {
                      isEditing = false; // Stop editing
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 150), // Make it wider
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
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color.fromARGB(255, 239, 222, 214), width: 1), // Border color
                  ),
                  backgroundColor: const Color.fromARGB(255, 245, 240, 255), // Remove background color
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
                  overflow: TextOverflow.ellipsis, // Ensure the text is in one line
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
