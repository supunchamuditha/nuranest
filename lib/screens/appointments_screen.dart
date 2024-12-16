import 'package:flutter/material.dart';
import 'package:nuranest/screens/my_appointments_screen.dart';
import 'package:nuranest/screens/psychologist_profile_screen.dart';
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv package
import 'package:nuranest/utils/loadOldAppointment.dart'; // Import the loadOldAppointment.dart file
import 'package:nuranest/utils/storage_helper.dart'; // Import the storage_helper.dart file

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

// Global variable to hold the doctor's full name
String? doctorFullName;
String? appointmentType;
String? specialization;

class _AppointmentsScreenState extends State<AppointmentsScreen> {
// Load the doctor details when the screen is initialized
  @override
  void initState() {
    super.initState();
    _loadDoctorDetails(); // Call the method with a sample doctorId
    loadOldAppointment(); // Call the method to load the old appointment
    _loadAppointmentDetails(); // Call the method to load the appointment details
  }

  // Load appointment details asynchronously
  Future<void> _loadAppointmentDetails() async {
    doctorFullName = await getDoctorFullName();
    appointmentType = await getAppointmentType();
    specialization = await getSpecialization();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // Light background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Appointments",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildReminderCard(context),
            const SizedBox(height: 16),
            _buildPsychologistCard(context),
            const SizedBox(height: 16),
            const Text(
              "Now Online",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPsychologistPopularGrid(),
            const SizedBox(height: 16),
            const Text(
              "Most Popular",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPsychologistPopularGrid(),
          ],
        ),
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
          icon:
              Icon(Icons.search, color: Colors.grey), // Search icon on the left
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none, // Remove the default underline border
        ),
        style: TextStyle(color: Colors.black), // Text color in the search bar
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
                          "You have a session with Dr. $doctorFullName today.",
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
            // Title text, avatar row, and online status
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0), // Left padding for the name and role text
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. $doctorFullName",
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
                            Text(
                              "$specialization",
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
                                Text(
                                  "$appointmentType      ",
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F5), // Change this color as needed
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '   Talk with me',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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

  // Widget _buildPsychologistOnlineGrid() {
  //   return SizedBox(
  //     height: 150, // Set the height to fit the CircleAvatar and text
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 6,
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) =>
  //                     PsychologistProfileScreen(), // Replace with the profile screen widget
  //               ),
  //             );
  //           },
  //           child: Container(
  //             width: MediaQuery.of(context).size.width /
  //                 3.8, // Show 3 items per screen width
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Stack(
  //                   children: [
  //                     CircleAvatar(
  //                       radius: 40,
  //                       backgroundImage: AssetImage(
  //                           "lib/assets/images/psychologist_avatar.png"), // Update the path
  //                     ),
  //                     Positioned(
  //                       top: 4,
  //                       right: 4,
  //                       child: Container(
  //                         width: 12,
  //                         height: 12,
  //                         decoration: BoxDecoration(
  //                           color:
  //                               Colors.green, // Green color for "online" status
  //                           shape: BoxShape.circle,
  //                           border: Border.all(
  //                               color: Colors.white,
  //                               width:
  //                                   1), // White border to separate from avatar
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   "Dr. Example...",
  //                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 Text(
  //                   "Psychologist",
  //                   style: TextStyle(color: Colors.grey, fontSize: 10),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Define a list to store the doctor details
  final List<Map<String, dynamic>> DoctorDetails = [];

  Future<void> _loadDoctorDetails() async {
    try {
      // Get the API URL from the .env file
      final apiUrl = dotenv.env['API_URL'];

      // Define the API endpoint
      final getDoctorUrl = Uri.parse('$apiUrl/doctors/');

      // Get the user's token from SharedPreferences
      String? token = await getToken();

      // Send a GET request to the API endpoint
      final response = await http.get(getDoctorUrl, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Decode the response
      final resDocData = json.decode(response.body);

      // Log the response status code
      // debugPrint('response.statusCode: ${response.statusCode}');
      // Log the decoded response
      // debugPrint('resDocData: $resDocData');

      // Check if the response is successful
      if (response.statusCode == 200 &&
          resDocData['doctors'] != null &&
          resDocData['doctors'] is List) {
        DoctorDetails.clear(); // Clear the list before adding new data
        DoctorDetails.addAll(
            List<Map<String, dynamic>>.from(resDocData['doctors']));

        // Log the doctor details
        // debugPrint('DoctorDetails: $DoctorDetails');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  Widget _buildPsychologistPopularGrid() {
// Define a variable to store the doctor's full name
    Future<String?> getDoctorFirstName(int userid) async {
      try {
        // Get the API URL from the .env file
        final apiUrl = dotenv.env['API_URL'];

        // Define the API endpoint for fetching doctor details
        final getDoctorUrl = Uri.parse('$apiUrl/users/$userid');

        // Get the user's token from SharedPreferences
        String? token = await getToken();

        // Send a GET request to the API endpoint
        final response = await http.get(getDoctorUrl, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

        // Decode the response
        final resDocData = json.decode(response.body);

        // Log the response status code
        // debugPrint('response.statusCode: ${response.statusCode}');
        // Log the decoded response
        // debugPrint('resDocData: $resDocData');
        // debugPrint('resDocData["user"]["first_name"]: ${resDocData["user"]}');

        // Check if the response is successful
        if (response.statusCode == 200 && resDocData['user'] != null) {
          return resDocData['user']['firstName'];
        } else {
          return "Unknown";
        }
      } catch (error) {
        debugPrint('Error: $error');
        return "Unknown";
      }
    }

    return SizedBox(
      height: 150, // Set the height to fit the CircleAvatar and text
      child: FutureBuilder(
        future: _loadDoctorDetails(), // Provide the future parameter
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center();
          } else if (DoctorDetails.isEmpty) {
            return Center(child: Text("No appointments available"));
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: DoctorDetails.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PsychologistProfileScreen(
                          doctorDetails: {
                            'DoctorDetails':
                                DoctorDetails[index], // Pass specialization
                          },
                        ), // Replace with the profile screen widget
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width /
                        3.8, // Show 3 items per screen width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                              "lib/assets/images/psychologist_avatar.png"), // Update the path
                        ),
                        const SizedBox(height: 4),
                        FutureBuilder<String?>(
                          future: getDoctorFirstName(DoctorDetails[index]
                              ['userId']), // Fetch doctor's name
                          builder: (context, nameSnapshot) {
                            if (nameSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.grey),
                              );
                            } else if (nameSnapshot.hasError) {
                              return Text("Error");
                            } else {
                              return Text(
                                "Dr. ${nameSnapshot.data ?? "Unknown"}",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              );
                            }
                          },
                        ),
                        Text(
                          "${DoctorDetails[index]['specialization']}",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
