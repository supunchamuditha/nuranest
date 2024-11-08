import 'package:flutter/material.dart';
import 'package:nuranest/screens/book_appointment_screen.dart';
import 'package:nuranest/screens/my_appointments_screen.dart';

class PsychologistProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Psychologist',
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
        
      ),
      
    ),
    
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Enlarged Profile Image
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4), // Border thickness
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 4), // Black border
            ),
            child: CircleAvatar(
              radius: 100, // Size of the image
              backgroundColor: Colors.grey.shade300,
              backgroundImage: AssetImage("lib/assets/images/psychologist_avatar.png"),
            ),
          ),



          const SizedBox(height: 16),

          // Contact options moved below image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Image.asset('lib/assets/icon/phone.png'),
                onPressed: () {},
                padding: const EdgeInsets.only(left: 20 , right: 20),
              ),
              IconButton(
                icon: Image.asset('lib/assets/icon/email.png'),
                onPressed: () {},
                padding: const EdgeInsets.only(left: 20 , right: 20),
              ),
              IconButton(
                icon: Image.asset('lib/assets/icon/video.png'),
                onPressed: () {},
                padding: const EdgeInsets.only(left: 20 , right: 0),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name and title
          const Text(
            'Dr. Shanez Fernando',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Slightly larger font
          ),
          const Text(
            'Psychologist',
            style: TextStyle(fontSize: 17, color: Colors.grey),
          ),
          const SizedBox(height: 16),
        
            const SizedBox(height: 20),

            // New reminder card
            _buildReminderCard(context),
            const SizedBox(height: 16),

            // Make an appointment button
            SizedBox(
              width: double.infinity, // Make the button as wide as the parent container (reminder card width)
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookAppointmentPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB0E5FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Make an appointment',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 17),
                ),
              ),
            ),
            const SizedBox(height: 20),


            // About section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Experienced psychologist offering personalized mental health support through confidential counseling and therapy sessions, helping individuals navigate stress, anxiety, and personal challenges to achieve emotional well-being and growth.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
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
                        "You have a session with ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                        Text(
                        " Mr. Fernando today.",
                        style: TextStyle(
                          fontSize: 16,
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
                    text: '   Go to ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                    children: [
                      TextSpan(
                        text: 'my Appointments',
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
                      MaterialPageRoute(builder: (context) => const MyAppointmentsScreen()),
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
