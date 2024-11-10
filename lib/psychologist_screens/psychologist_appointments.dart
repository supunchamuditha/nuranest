import 'package:flutter/material.dart';
import 'package:nuranest/psychologist_screens/view_user_profile.dart';

class PsychologistAppointments extends StatelessWidget {
  const PsychologistAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // Light pinkish background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
        title: const Text(
          'Appointments',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10), // Top padding

          // Profile card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dr. Shanez Fernando',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Psychologist',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.circle, color: Colors.green, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15), // Space between card and button

          // "Change my appointment details" button
          ElevatedButton(
            onPressed: () {
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEFE0D6), // Light peach color for button background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
            ),
            child: const Text(
              'Change my appointment details',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),


          const SizedBox(height: 15), // Space between button and search bar

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFEFE0D6), // Light peach color
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20), // Space before "No more Appointments" text

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReminderCard(context),
                const SizedBox(height: 16),
                _buildPatientCard(context),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // "No more Appointments" text
          const Text(
            'No more Appointments',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey,
              fontSize: 14,
            ),
          ),

          const Spacer(), // Pushes bottom navigation to bottom

          // Bottom navigation bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFFEFE0D6), // Bottom navigation background color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('lib/assets/images/18.png'), // Replace with the actual image path
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
  }
  Widget _buildReminderCard(BuildContext context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E7E0), // Light pink background color
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title text and avatar row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0), // Left padding for the image
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: const AssetImage("lib/assets/images/reminder_avatar.png"), // Replace with your actual path
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0), // Left padding for the reminder text
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Supun Maduranga",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "07.00 PM - 08.00 PM",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // New rounded corner box for appointments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F5), // Change this color as needed
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    text: '   Meet My',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                    children: [
                      TextSpan(
                        text: ' Patient',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ViewUserProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xFFFFE86C), // Yellowish button color
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  
Widget _buildPatientCard(BuildContext context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF7E7E0), // Light pink background color
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title text, avatar row, and online status
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0), // Left padding for the name and role text
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Supun Maduranga",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "07.00PM - 08.00PM",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          // Online status indicator aligned with "Psychologist"
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "Online      ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // New rounded corner box for appointments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F5), // Change this color as needed
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   31/12/2024',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

  