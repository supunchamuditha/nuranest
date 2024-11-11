import 'package:flutter/material.dart';
import 'package:nuranest/screens/appointments_screen.dart';
import 'package:nuranest/screens/chatlist.dart';
import 'package:nuranest/screens/my_appointments_screen.dart';
import 'package:nuranest/screens/profile_page.dart';
import 'package:nuranest/screens/user_article.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add this for navigation
  int _selectedIndex = 0;

  // List of screens for navigation
  final List<Widget> _pages = [
    const HomeScreenContent(), // Home Screen Content (not the HomeScreen itself)
    ChatListPage(),  // Replace with your actual GetStartedScreen
    const MyAppointmentsScreen(),   // Replace with your actual MakePaymentPage
    const ProfilePage(),       // Replace with your actual LoginScreen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: _pages[_selectedIndex], // Display the selected screen

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // This will control the selected tab
        onTap: _onItemTapped, // Update the selected index on tap
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: ' My Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

// Separate widget for HomeScreen content (previously in your HomeScreen)
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // List of mood labels for easy reference
  final List<String> moodLabels = ["Angry", "Sad", "Calm", "Happy", "Excited"];
  
  // Selected mood index (default to "Calm")
  int selectedMoodIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Hey, <Name> 👋",
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
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(moodLabels.length, (index) {
          return _buildMoodIcon(
            'lib/assets/icon/${moodLabels[index].toLowerCase()}.png',
            moodLabels[index],
            index == selectedMoodIndex, // Highlight the selected mood
            index,
          );
        }),
      ),
    );
  }

  Widget _buildMoodIcon(String iconPath, String label, bool isActive, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMoodIndex = index; // Update selected mood index
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFE86C) : Colors.transparent, // Yellow background for active icon
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: 40,
              height: 40,
              color: const Color(0xFFD4A373), // Icon color
            ),
            if (isActive)
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4A373),
                ),
              ),
          ],
        ),
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
                          "I'm Here To Remind You,",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "You have a session with \n <Psychologist_name> today.",
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
                      fontSize: 17,
                    ),
                    children: [
                      TextSpan(
                        text: 'Make Appointment',
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
                      MaterialPageRoute(builder: (context) => const AppointmentsScreen()),
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
          const SizedBox(height: 155), // Add space if you need it between image and button row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F5).withOpacity(0.9), // Light background with transparency
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
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: 'articles',
                        style: TextStyle(
                          fontSize: 18,
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
                      MaterialPageRoute(builder: (context) => const UserArticle()),
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

}

