import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // Light background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Hey, Name 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "How are you feeling today?",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 16),
            _buildMoodSelector(),
            const SizedBox(height: 30),
            _buildReminderCard(context),
            const SizedBox(height: 20),
            _buildPsychologistCard(context),
            const SizedBox(height: 20),
            _buildArticlesCard(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMoodIcon(Icons.sentiment_dissatisfied, Colors.redAccent),
        _buildMoodIcon(Icons.sentiment_neutral, Colors.orange),
        _buildMoodIcon(Icons.sentiment_satisfied, Colors.yellow),
        _buildMoodIcon(Icons.sentiment_very_satisfied, Colors.green),
        _buildMoodIcon(Icons.sentiment_very_satisfied, Colors.blueAccent),
      ],
    );
  }

  Widget _buildMoodIcon(IconData icon, Color color) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      radius: 24,
      child: Icon(icon, color: color, size: 24),
    );
  }

  // Widget _buildReminderCard(BuildContext context) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     color: Color(0xFFEFDED6), // Soft pinkish background
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Row(
  //         children: [
  //           CircleAvatar(
  //             radius: 30,
  //             backgroundImage: AssetImage('lib/assets/images/reminder_avatar.png'),
  //           ),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   "I'm Here To Remind You",
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 const Text(
  //                   "You have a session with Mr. Fernando today.",
  //                   style: TextStyle(fontSize: 14, color: Colors.black54),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 GestureDetector(
  //                   onTap: () {
  //                     // Navigate to appointments
  //                   },
  //                   child: Row(
  //                     children: const [
  //                       Text(
  //                         "Go to my Appointments",
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.blueAccent,
  //                         ),
  //                       ),
  //                       Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueAccent),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


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
                        "I'm Here To Remind You,",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "You have a session with Mr. Fernando today.",
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
                    text: 'Go to ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'my Appointments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add navigation or functionality here
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

Widget _buildPsychologistCard(BuildContext context) {
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
              
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0), // Left padding for the reminder text
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Meet your psychologist",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
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
                    text: 'Go to ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Make Appointment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add navigation or functionality here
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

  // Widget _buildPsychologistCard(BuildContext context) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     color: Color(0xFFEFDED6), // Light peach color
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   "Meet your psychologist",
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 GestureDetector(
  //                   onTap: () {
  //                     // Navigate to make an appointment
  //                   },
  //                   child: Row(
  //                     children: const [
  //                       Text(
  //                         "Go to Make Appointment",
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.blueAccent,
  //                         ),
  //                       ),
  //                       Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueAccent),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const Icon(Icons.event_available, color: Colors.yellow, size: 48),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildArticlesCard(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    color: const Color(0xFFF5EDD3), // Light beige color
    child: Container(
      // Remove padding from Padding widget and add to Container
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: AssetImage('lib/assets/images/read_articles.png'), // Replace with your image path
          fit: BoxFit.cover,
          
        ),
        
      ),
      
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 150), // Add space if you need it between image and button row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F5).withOpacity(1), // Light background with transparency
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Go to ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Make Appointment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add navigation or functionality here
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



  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }



}