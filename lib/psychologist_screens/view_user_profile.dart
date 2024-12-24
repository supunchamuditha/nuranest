import 'package:flutter/material.dart';
import 'package:nuranest/screens/chat_screen.dart';
import 'package:nuranest/utils/storage_helper.dart'; // Import the storage_helper.dart file
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv package
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; //

class ViewUserProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ViewUserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ViewUserProfileScreenState createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    userData = widget.user;
    _loadUserDetails();
  }

  bool isLoading = false;

  String? patientName;
  String? patientAge;
  String? patientAddress;
  String? patientAdditionalInfo;
  String? patientDuration;
  String? patientType;
  String? patientAppointmentTime;

  Future<void> _loadUserDetails() async {
    try {
      // Set the loading state to true
      setState(() {
        isLoading = true;
      });

      // Retrieve user token
      final token = await _getUserToken();
      if (token == null) throw Exception("Token not found");

      int? patientId = userData['id'];
      int? appointmentId = userData['appointmentId'];

      // Fetch user details using the token
      final userDetails = await _fetchUserDetails(token, patientId);

      // Fetch appointment details
      final appointmentDetails =
          await _fetchAppointmentDetails(token, appointmentId);

      // Store or process user details
      // debugPrint('User details: $userDetails');

      // Store or process appointment details
      debugPrint('Appointment details: $appointmentDetails');

      // Fetch patient name
      final patientname = await _getPatientName(userDetails);

      // Fetch patient age
      final age = await _getPatientAge(userDetails);

      // Fetch patient appontment time
      final appointmentTime = await _getAppointmentTime(appointmentDetails);

      setState(() {
        patientName = patientname;
        patientAge = age.toString();
        patientAddress = userDetails['address'];

        patientAppointmentTime = appointmentTime;

        patientAdditionalInfo = appointmentDetails['additionalInfo'];
        patientDuration = "1hr";
        patientType = appointmentDetails['appointmentType'];
      });
    } catch (error) {
      debugPrint('Error: $error');
    } finally {
      // Set the loading state to false
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> _getUserToken() async {
    try {
      return await getToken();
    } catch (error) {
      debugPrint('Failed to retrieve token: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> _fetchUserDetails(
      String token, int? patientId) async {
    if (patientId == null) {
      throw Exception('Patient ID is null');
    }

    final apiUrl = dotenv.env['API_URL'];
    final endpoint = '$apiUrl/users/$patientId';

    final response = await http.get(Uri.parse(endpoint), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    final responseData = jsonDecode(response.body);
    _validateResponse(response, 'Failed to fetch user details');
    return responseData['user'];
  }

  Future<Map<String, dynamic>> _fetchAppointmentDetails(
      String token, int? appointmentId) async {
    if (appointmentId == null) {
      throw Exception('Appointment ID is null');
    }

    final apiUrl = dotenv.env['API_URL'];
    final endpoint = '$apiUrl/appointments/$appointmentId';

    final response = await http.get(Uri.parse(endpoint), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    final responseData = jsonDecode(response.body);
    _validateResponse(response, 'Failed to fetch appointment details');
    return responseData['appointment'];
  }

  Future<String?> _getPatientName(Map<String, dynamic> userDetails) async {
    String? firstName = userDetails['firstName'];
    String? lastName = userDetails['lastName'];
    return '$firstName $lastName';
  }

  Future<int?> _getPatientAge(Map<String, dynamic> userDetails) async {
    DateTime birthDate = DateTime.parse(userDetails['dob']);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<String?> _getAppointmentTime(
      Map<String, dynamic> appointmentDetails) async {
    String? appointmentTime = appointmentDetails['appointmentTime'];
    appointmentTime = appointmentTime?.substring(0, 5); // Remove seconds

    return appointmentTime;
  }

  void _validateResponse(http.Response response, String errorMessage) {
    if (response.statusCode != 200) {
      throw Exception('$errorMessage: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '$patientName',
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
                border:
                    Border.all(color: Colors.black, width: 4), // Black border
              ),
              child: CircleAvatar(
                radius: 100, // Size of the image
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage("lib/assets/images/18.png"),
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
                  padding: const EdgeInsets.only(left: 20, right: 20),
                ),
                IconButton(
                  icon: Image.asset('lib/assets/icon/email.png'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen('Chat Partner Name'),
                      ),
                    );
                  },
                  padding: const EdgeInsets.only(left: 20, right: 20),
                ),
                IconButton(
                  icon: Image.asset('lib/assets/icon/video.png'),
                  onPressed: () {},
                  padding: const EdgeInsets.only(left: 20, right: 0),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Name and title
            Text(
              '$patientName',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold), // Slightly larger font
            ),
            Text(
              '$patientAge years old',
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 20),

            // New reminder card
            _buildReminderCard(context, patientName, patientAppointmentTime),
            const SizedBox(height: 16),

            // About section
            const Align(
              alignment: Alignment.center,
              child: Text(
                'About',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$patientAddress",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Additional Info',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$patientAdditionalInfo",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 8),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Duration',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$patientDuration",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 8),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$patientType",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

Widget _buildReminderCard(
    BuildContext context, String? patientName, String? patientAppointmentTime) {
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
                        "$patientName",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "$patientAppointmentTime",
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
                    text: '   Start',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                    children: [
                      TextSpan(
                        text: ' Now',
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
                    //       builder: (context) => ViewUserProfileScreen()),
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
