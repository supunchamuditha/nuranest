import 'package:flutter/material.dart';
import 'package:nuranest/psychologist_screens/psychologist_appointments.dart';
import 'package:nuranest/psychologist_screens/psychologist_article_view.dart';
import 'package:nuranest/psychologist_screens/psychologist_chatlist_page.dart';
import 'package:nuranest/screens/profile_page.dart';

class PsychologistArticle extends StatefulWidget {
  const PsychologistArticle({Key? key}) : super(key: key);

  @override
  _PsychologistArticleState createState() => _PsychologistArticleState();
}

class _PsychologistArticleState extends State<PsychologistArticle> {
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
                    text: 'View ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: 'article',
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
                        MaterialPageRoute(builder: (context) => const PsychologistArticleView()),
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

