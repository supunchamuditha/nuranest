import 'package:flutter/material.dart';
import 'package:nuranest/psychologist_screens/psychologist_appointments.dart';
import 'package:nuranest/psychologist_screens/psychologist_chatlist_page.dart';
import 'package:nuranest/screens/profile_page.dart';

class UserArticleView extends StatefulWidget {
  const UserArticleView({Key? key}) : super(key: key);

  @override
  _UserArticleViewState createState() => _UserArticleViewState();
}

class _UserArticleViewState extends State<UserArticleView> {
  // Add this for navigation
  int _selectedIndex = 0;

  // List of screens for navigation
  final List<Widget> _pages = [
    const HomeScreenContent(), // Home Screen Content (not the HomeScreen itself)
    PsychologistChatlistPage(),  // Replace with your actual GetStartedScreen
    const PsychologistAppointments(),   // Replace with your actual MakePaymentPage
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          const SizedBox(height: 30),
          _buildSearchBar(),
          const SizedBox(height: 30),
          _buildReadArticleCard(context),
        ],
      ),
    );
  }

Widget _buildSearchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      decoration: InputDecoration(
        icon: Icon(Icons.search, color: Colors.grey), // Search icon on the left
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        border: InputBorder.none, // Remove the default underline border
      ),
      style: TextStyle(color: Colors.black), // Text color in the search bar
    ),
  );
}
  

  Widget _buildReadArticleCard(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    color: const Color(0xFFF5EDD3), // Light beige color
    child: Padding(
      padding: const EdgeInsets.all(20), // Add padding around the content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Effects of Sleep Deprivation",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Image.asset(
                'lib/assets/images/character_icon.png', // Replace with your image path
                width: 50,
                height: 50,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Sleep deprivation has a significant impact on cognitive function, emotional stability, and physical health. Lack of adequate sleep impairs memory, concentration, and decision-making, while increasing irritability and emotional sensitivity.\n\n"
            "Prolonged sleep deprivation can lead to severe mental health issues, including anxiety and depression, as well as weakened immunity and a higher risk of chronic illnesses like heart disease and diabetes.\n\n"
            "Prioritizing sleep is crucial for overall well-being and performance.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE9DD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ACSC SampleName\n2014/01/01",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add navigation or functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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