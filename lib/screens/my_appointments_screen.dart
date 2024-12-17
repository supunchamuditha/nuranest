import 'package:flutter/material.dart';
import 'package:nuranest/screens/appointments_screen.dart';
// import 'package:nuranest/screens/psychologist_profile_screen.dart';
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library
import 'package:intl/intl.dart'; // Import the intl library
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv library
import 'package:nuranest/utils/storage_helper.dart'; // Import the storage_helper.dart file
import 'package:nuranest/utils/loadOldAppointment.dart'; // Import the loadOldAppointment.dart file
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder library

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({Key? key}) : super(key: key);

  @override
  _MyAppointmentsScreenState createState() => _MyAppointmentsScreenState();
}

// Global variable to hold the doctor's full name
String? doctorFullName;
String? appointmentTime;
String? appointmentDate;

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _loadAppointmentDetails();
  }

  // Load appointment details asynchronously
  Future<void> _loadAppointmentDetails() async {
    doctorFullName = await getDoctorFullName();
    appointmentTime = await getAppointmentTime();
    appointmentDate = await getAppointmentDate();
    setState(() {});
  }

  // Define a list to store the appointments details
  final List<Map<String, dynamic>> appointmentsDetails = [];

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
          Uri.parse('$apiUrl/appointments/patients/$userId');

      // Get the user's token from SharedPreferences
      token = await getToken();

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

      // Check if 'appointments' exists in the response and is a list
      if (resAppData['appointments'] != null &&
          resAppData['appointments'] is List) {
        // Cast and store the appointments in the psychologists list
        appointmentsDetails.clear(); // Clear previous data if necessary
        appointmentsDetails.addAll(
            List<Map<String, dynamic>>.from(resAppData['appointments']));

        // Log the psychologists list
        // debugPrint('Psychologists: $appointmentsDetails');
      } else {
        debugPrint('Appointments not found');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Light background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        
        title: const Text(
          "My Appointments",
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
            _setAppointmentCard(context),
            const SizedBox(height: 16),
            _buildReminderCard(context),
            const SizedBox(height: 16),

            // Generate appointment cards from the appointments list
            FutureBuilder(
              future: _loadAppointments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (appointmentsDetails.isEmpty) {
                  return Center(child: Text("No appointments available"));
                } else {
                  return ListView.builder(
                    shrinkWrap: true, // ListView will size to fit its children
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent internal scrolling
                    itemCount: appointmentsDetails.length,
                    itemBuilder: (context, index) {
                      return _buildPsychologistCard(
                          context, appointmentsDetails[index]);
                    },
                  );
                }
              },
            ),
            // _buildPsychologistCard(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                          "Dr.$doctorFullName",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$appointmentTime, $appointmentDate",
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
                          text: ' Psychologist',
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => PsychologistProfileScreen("he")),
                      // );
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

  Widget _buildPsychologistCard(
      BuildContext context, Map<String, dynamic> appointment) {
    // Get the doctor ID
    String doctorId = appointment['doctorId'].toString();
    // Get the appointment date
    String? appointmentDate = appointment['appointmentDate'];
    // Format the date to "DD-MM-YYYY" format
    appointmentDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(appointmentDate!));

    // Get the appointment time
    String? appointmentTime = appointment['appointmentTime'];
    //Remove the seconds from the time
    appointmentTime = appointmentTime?.substring(0, 5);

    // Get the appointment type
    String? appointmentType = appointment['appointmentType'];
    // Capitalize the first letter of the appointment type
    appointmentType = appointmentType![0].toUpperCase() +
        appointmentType.substring(1).toLowerCase();

    // Log the appointment details
    // debugPrint("appointment: ${appointment.toString()}");
    // Log the appointment Doctor ID
    // debugPrint("Doctor ID: $doctorId");
    // Log the appointment time
    // debugPrint('appointmentTime: $appointmentTime');
    // Log the appointment date
    // debugPrint('appointmentDate: $appointmentDate');
    // Log the appointmentType
    // debugPrint('appointmentType: $appointmentType');
    // Log the doctorFullName
    // debugPrint('doctorFullName: $doctorFullName');

    // Define a variable to store the doctor's full name
    Future<String?> getDoctorFirstName(int doctorId) async {
      try {
        // Get the API URL from the .env file
        final apiUrl = dotenv.env['API_URL'];

        // Define the API endpoint for fetching doctor details
        final getDoctorUrl = Uri.parse('$apiUrl/doctors/$doctorId');

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
        // Log the response body
        // debugPrint('response.body: ${response.body}');
        // Log the decoded response
        // debugPrint('resDocData: ${resDocData['doctor']}');
        // debugPrint('resDocData["user"]["first_name"]: ${resDocData["user"]}');

        // Check if the response is successful
        if (response.statusCode == 200 && resDocData['doctor'] != null) {
          // Get user ID
          int userId = resDocData['doctor']['userId'];

          // Log the user ID
          // debugPrint('userId: $userId');

          // Define the API endpoint for fetching user details
          final getUserUrl = Uri.parse('$apiUrl/users/$userId');

          // Send a GET request to the API endpoint
          final userResponse = await http.get(getUserUrl, headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });

          // Decode the response
          final resUserData = json.decode(userResponse.body);

          // Log the response status code
          // debugPrint('userResponse.statusCode: ${userResponse.statusCode}');
          // Log the response body
          // debugPrint('userResponse.body: ${userResponse.body}');
          // Log the decoded response
          // debugPrint('resUserData: ${resUserData['user']}');

          // Get the doctor's first name and last name
          String fistname = resUserData['user']['firstName'];
          String lastname = resUserData['user']['lastName'];

          // Combine the first name and last name
          String? doctorFullName = "$fistname $lastname";

          // debugPrint("Fuk u this code is working");

          // Log the doctor's full name
          return doctorFullName;
        } else {
          return "Unknown";
        }
      } catch (error) {
        debugPrint('Error: $error');
        return "Unknown";
      }
    }

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
                        FutureBuilder<String?>(
                          future: getDoctorFirstName(
                              int.parse(doctorId)), // Fetch doctor's name
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appointmentTime!,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F5), // Change this color as needed
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appointmentDate,
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

  Widget _setAppointmentCard(BuildContext context) {
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
                          "Want to make another appointmnt ?",
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
                      text: '   Go to ',
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
}
