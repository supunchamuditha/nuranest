import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nuranest/screens/appointments_screen.dart';
import 'package:nuranest/screens/chatbot.dart';
import 'package:nuranest/screens/chatlist.dart';
import 'package:nuranest/screens/my_appointments_screen.dart';
import 'package:nuranest/screens/profile_page.dart';
import 'package:nuranest/screens/user_article.dart';
import 'package:nuranest/utils/storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library
import 'package:intl/intl.dart'; // Import the intl library
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder library

// Global variable to hold the doctor's full name
String? doctorFullName;
String? appointmentTime;
String? appointmentDate;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add this for navigation
  int _selectedIndex = 0;

  // List of screens for navigation
  final List<Widget> _pages = [
    const HomeScreenContent(), // Home Screen Content (not the HomeScreen itself)
    ChatListPage(), // Replace with your actual GetStartedScreen
    const MyAppointmentsScreen(), // Replace with your actual MakePaymentPage
    const ProfilePage(), // Replace with your actual LoginScreen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: _pages[_selectedIndex], // Display the selected screen

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // This will control the selected tab
        onTap: _onItemTapped, // Update the selected index on tap
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined), label: 'Appointments'),
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
  String? userName; // Default usernamep
  int? userId; // Default userId

  bool _isAppointment = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadAppointments();
  }

  // Load the user's username from SharedPreferences
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetails = prefs.getString('user'); // Get the user JSON string

    if (userDetails != null) {
      // Parse the JSON string into a Map
      Map<String, dynamic> user = json.decode(userDetails);

      setState(() {
        // Log the user data
        // debugPrint('user: $user');

        // Retrieve the userId from the JSON
        userId = user['id'];
        // Retrieve the firstName from the JSON
        userName = user['username'];

        // Log the userId
        // debugPrint('userId: $userId');
        // Log the username
        // debugPrint('username: $userName');
      });

      // print('username: $userName'); // Log the first name
    } else {
      setState(() {
        userName = 'User'; // Default to 'User' if no data is found
      });
    }
  }

  // Load appointments from the API
  Future<void> _loadAppointments() async {
    try {
      // Get the API URL from the .env file
      final apiUrl = dotenv.env['API_URL'];

      // Get the user's token from SharedPreferences
      String? token = await getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Extract the user ID (or any other field you need)
      int? userId = decodedToken['id'];

      // Define the API endpoint
      final getAppointmentUrl =
          Uri.parse('$apiUrl/appointments/patients/$userId/upcoming');

      // Set the _isAppointment variable to false
      setState(() {
        _isAppointment = false;
      });

      // Send a GET request to the API endpoint
      final response = await http.get(getAppointmentUrl, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Decode the response
      final resAppData = json.decode(response.body);

      // Log the response
      // debugPrint('response: $response');
      // Log the response status code
      // debugPrint('response.statusCode: ${response.statusCode}');
      // Log the response body
      // debugPrint('response.body: ${response.body}');
      // Log the decoded response
      // debugPrint('resAppData: ${resAppData['appointments']}');
      // Get the older appointment
      // debugPrint('resAppData first: ${resAppData['appointments'].first}');
      // Get the latest appointment
      // debugPrint('resAppData last: ${resAppData['appointments'].last}');
      // Get the oldser appointment doctor id
      // debugPrint(
      //     'resAppData older doctor id: ${resAppData['appointments'].first['doctorId']}');

      // Check if there are any appointments
      if (response.statusCode == 200 &&
          resAppData['appointments'] != null &&
          resAppData['appointments'].isNotEmpty) {
        // Get the doctorId from the last appointment
        int? doctorId = resAppData['appointments'].first['doctorId'];

        // Log the doctorId
        // debugPrint('doctorId: $doctorId');

        // Get the doctor's details from the API
        final getDoctorUrl = Uri.parse('$apiUrl/doctors/$doctorId');

        // Send a GET request to the API endpoint
        final doctorResponse = await http.get(getDoctorUrl, headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        });

        // Decode the response
        final resDoctorData = json.decode(doctorResponse.body);

        // Log the response
        // debugPrint('doctorResponse: $doctorResponse');
        // Log the response status code
        // debugPrint('doctorResponse.statusCode: ${doctorResponse.statusCode}');
        // Log the response body
        // debugPrint('doctorResponse.body: ${doctorResponse.body}');
        // Log the decoded response
        // debugPrint('resDoctorData: ${resDoctorData['doctor']}');
        // Get the doctor's userId
        // debugPrint('resDoctorData id: ${resDoctorData['doctor']['userId']}');

        // Check if the response is successful
        if (doctorResponse.statusCode == 200 &&
            resDoctorData['doctor'] != null &&
            resDoctorData['doctor'].isNotEmpty) {
          // Get the doctor's userId
          int? doctorUserId = resDoctorData['doctor']['userId'];

          // Log the doctor's userId
          // debugPrint('doctorUserId: $doctorUserId');

          // Get the user's details from the API
          final getUserUrl = Uri.parse('$apiUrl/users/$doctorUserId');

          // Send a GET request to the API endpoint
          final userResponse = await http.get(getUserUrl, headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token',
          });

          // Decode the response
          final resUserData = json.decode(userResponse.body);

          // Log the response
          // debugPrint('userResponse: $userResponse');
          // Log the response status code
          // debugPrint('userResponse.statusCode: ${userResponse.statusCode}');
          // Log the response body
          // debugPrint('userResponse.body: ${userResponse.body}');
          // Log the decoded response
          // debugPrint('resUserData: ${resUserData['user']}');
          // Get the user's fistname
          // debugPrint(
          // 'resUserData fistname: ${resUserData['user']['firstName']}');
          // Get the user's lastname
          // debugPrint(
          // 'resUserData lastname: ${resUserData['user']['lastName']}');

          // Check if the response is successful
          if (userResponse.statusCode == 200 &&
              resUserData['user'] != null &&
              resUserData['user'].isNotEmpty) {
            // Get the user's firstName
            String? doctorFirstName = resUserData['user']['firstName'];

            // Get the user's lastName
            String? doctorLastName = resUserData['user']['lastName'];

            // Log the doctor's firstName
            // debugPrint('doctorFirstName: $doctorFirstName');
            // Log the doctor's lastName
            // debugPrint('doctorLastName: $doctorLastName');

            // Check if the doctor's firstName and lastName are not null
            if (doctorFirstName != null && doctorLastName != null) {
              // Set the doctor's full name
              doctorFullName = '$doctorFirstName $doctorLastName';

              // Get the appointment time
              appointmentTime =
                  resAppData['appointments'].first['appointmentTime'];
              //Remove the seconds from the time
              appointmentTime = appointmentTime?.substring(0, 5);

              // Get the appointment date
              appointmentDate =
                  resAppData['appointments'].first['appointmentDate'];
              // Format the date to "DD-MM-YYYY" format
              appointmentDate = DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(appointmentDate!));

              // Set the _isAppointment variable to true
              setState(() {
                _isAppointment = true;
              });

              // Log the doctor's full name
              // debugPrint('doctorFullName: $doctorFullName');
              // Log the appointment time
              // debugPrint('appointmentTime: $appointmentTime');
              // Log the appointment date
              // debugPrint('appointmentDate: $appointmentDate');
            }
          }
        }
      } else {
        // Set the _isAppointment variable to false
        setState(() {
          _isAppointment = false;
        });
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // Selected mood index (default to "Calm")
  int selectedMoodIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content (ScrollView)
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Hey, $userName 👋",
                  style: const TextStyle(
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
          // Floating Button
          Positioned(
            bottom: 16, // Fixed distance from the bottom
            right: 16, // Fixed distance from the right
            child: SizedBox(
              width: 70, // Custom width
              height: 70, // Custom height
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AIChatPage()),
                  );
                },
                backgroundColor:
                    Color.fromARGB(255, 233, 218, 212), // Gray-beige color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      50), // Adjust this value for desired rounding
                ),
                child: Icon(
                  Icons.chat,
                  color: Colors.black, // Icon color for better contrast
                  size: 30, // Adjust icon size to fit the button
                ),
              ),
            ),
          ),
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

  Widget _buildMoodIcon(
      String iconPath, String label, bool isActive, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMoodIndex = index; // Update selected mood index
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFFFE86C)
              : Colors.transparent, // Yellow background for active icon
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
                  padding: const EdgeInsets.only(
                      left: 10.0), // Left padding for the image
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: const AssetImage(
                        "lib/assets/images/reminder_avatar.png"), // Replace with your actual path
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0), // Left padding for the reminder text
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "I'm Here To Remind You,",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "You have a session with \n Dr. $doctorFullName,\n $appointmentDate, $appointmentTime.",
                          style: const TextStyle(
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
                          text: 'My Appointments',
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
                        MaterialPageRoute(
                            builder: (context) => const MyAppointmentsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder(),
                      backgroundColor:
                          const Color(0xFFFFE86C), // Yellowish button color
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
                    padding: const EdgeInsets.only(
                        left: 10.0), // Left padding for the reminder text
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
                        MaterialPageRoute(
                            builder: (context) => const AppointmentsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder(),
                      backgroundColor:
                          const Color(0xFFFFE86C), // Yellowish button color
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
            image: AssetImage(
                'lib/assets/images/read_articles.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
                height:
                    155), // Add space if you need it between image and button row
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserArticle()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF9F5)
                      .withOpacity(0.9), // Light background with transparency
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
                        // Optional: You can leave this or remove it
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserArticle()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: const CircleBorder(),
                        backgroundColor:
                            const Color(0xFFFFE86C), // Yellowish button color
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
