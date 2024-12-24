import 'package:flutter/material.dart';
// import 'package:nuranest/psychologist_screens/profile_setup.dart';
import 'package:nuranest/psychologist_screens/view_user_profile.dart';
import 'package:nuranest/utils/storage_helper.dart'; // Import the storage_helper.dart file
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv package
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import the convert package
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder package
import 'package:intl/intl.dart'; // Import the intl library

class PsychologistAppointments extends StatefulWidget {
  const PsychologistAppointments({super.key});

  @override
  _PsychologistAppointmentsState createState() =>
      _PsychologistAppointmentsState();
}

class _PsychologistAppointmentsState extends State<PsychologistAppointments> {
  @override
  void initState() {
    super.initState();
    // _loadAppointments();
    _loadAppointments().then((_) async {
      await filterTodayAppointments();
    });
  }

  // Define a list to store the appointments data
  final List<Map<String, dynamic>> appointmentsFullDetails = [];

  // Define a variable to store the loading state
  bool _isLoading = false;

  // Load the appointments data from the database
  Future<void> _loadAppointments() async {
    try {
      // Set the loading state to true
      setState(() {
        _isLoading = true;
      });

      // Retrieve user token
      final token = await _getUserToken();
      if (token == null) throw Exception("Token not found");

      // Decode token to get user ID
      final userId = _getUserIdFromToken(token);

      // Fetch doctor information
      final doctorId = await _fetchDoctorId(userId, token);

      // Fetch doctor's appointments
      final appointmentsDetails =
          await _fetchDoctorAppointments(doctorId, token);

      // Cache patient data to avoid duplicate network calls
      final Map<int, dynamic> patientCache = {};

      // Build full appointment details
      for (var appointment in appointmentsDetails) {
        final patientId = appointment['patientId'];
        final patient =
            await _fetchPatientDetails(patientId, token, patientCache);

        appointmentsFullDetails.add({
          'appointment': appointment,
          'patient': patient,
        });
      }

      // debugPrint(
      //     'Appointments Full Details: ${appointmentsFullDetails.length}');
    } catch (error) {
      debugPrint('Error: $error');
    } finally {
      // Set the loading state to false
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getUserToken() async {
    return await getToken();
  }

  int _getUserIdFromToken(String token) {
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken['id'];
  }

  Future<int> _fetchDoctorId(int userId, String token) async {
    final apiUrl = dotenv.env['API_URL'];
    final endpoint = '$apiUrl/doctors/user/$userId';

    final response = await http.get(Uri.parse(endpoint), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    _validateResponse(response, 'Failed to load doctor profile');
    final responseBody = json.decode(response.body);

    return responseBody['doctor']['id'];
  }

  Future<List<Map<String, dynamic>>> _fetchDoctorAppointments(
      int doctorId, String token) async {
    final apiUrl = dotenv.env['API_URL'];
    final endpoint = '$apiUrl/appointments/doctors/$doctorId/';

    final response = await http.get(Uri.parse(endpoint), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    _validateResponse(response, 'Failed to load appointments');
    final responseBody = json.decode(response.body);

    return List<Map<String, dynamic>>.from(responseBody['appointments']);
  }

  Future<Map<String, dynamic>> _fetchPatientDetails(
      int patientId, String token, Map<int, dynamic> cache) async {
    if (cache.containsKey(patientId)) {
      return cache[patientId];
    }

    final apiUrl = dotenv.env['API_URL'];
    final endpoint = '$apiUrl/userS/$patientId';

    final response = await http.get(Uri.parse(endpoint), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    _validateResponse(response, 'Failed to load patient details');
    final responseBody = json.decode(response.body);

    cache[patientId] = responseBody['user'];
    return responseBody['user'];
  }

  void _validateResponse(http.Response response, String errorMessage) {
    if (response.statusCode != 200) {
      throw Exception('$errorMessage: ${response.reasonPhrase}');
    }
  }

  List<Map<String, dynamic>> todayAppointments = [];

  bool _isShow = false;

  Future<void> filterTodayAppointments() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get today's date
      final today = DateTime.now();

      // Clear the todayAppointments list before filtering
      todayAppointments.clear();

      if (appointmentsFullDetails.isEmpty) {
        setState(() {
          _isLoading = false;
          return;
        });
      }

      // Filter appointmentsFullDetails to find today's appointments
      todayAppointments = appointmentsFullDetails.where((details) {
        final appointmentDate =
            DateTime.parse(details['appointment']['appointmentDate']);

        // Check if the appointment date is today
        return appointmentDate.year == today.year &&
            appointmentDate.month == today.month &&
            appointmentDate.day == today.day;
      }).toList();

      // debugPrint("Today's Appointments: ${todayAppointments.length}");

      if (todayAppointments.isEmpty) {
        setState(() {
          _isLoading = false;
          _isShow = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isShow = true;
        });
      }
    } catch (error) {
      debugPrint("Error filtering today's appointments: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Light pinkish background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            Navigator.pop(
                context); // This will pop the current screen from the navigation stack.
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ProfileSetupScreen()),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: const Color(0xFFEFE0D6),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //     minimumSize: const Size(370, 50),
          //   ),
          //   child: const Text(
          //     'Change my appointment details',
          //     style: TextStyle(
          //       fontFamily: 'Poppins',
          //       fontWeight: FontWeight.w500,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // _buildReminderCard(context),
                // const SizedBox(height: 16),

                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (appointmentsFullDetails.isEmpty)
                  const Center(child: Text('No more Appointments'))
                else
                  _buildReminderCardSection(context),
                ...appointmentsFullDetails
                    .map((data) => _buildAppointmentCardSection(data))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCardSection(BuildContext context) {
    return Column(
      children: [
        if (!_isShow)
          Column(
            children: [
              const Center(
                child: Text(
                  'No appointments for today',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
        else
          ...todayAppointments
              .map((data) => _buildReminderCards(data))
              .toList(),
      ],
    );
  }

  Widget _buildReminderCards(Map<String, dynamic> data) {
    final appointment = data['appointment'];
    final patient = data['patient'];

    String? patientName = '${patient['firstName']} ${patient['lastName']}';
    String? appointmentTime = appointment['appointmentTime'];
    appointmentTime = appointmentTime?.substring(0, 5); // Remove seconds
    // String? appointmentDate = appointment['appointmentDate'];
    // appointmentDate =
    //     DateFormat('yyyy-MM-dd').format(DateTime.parse(appointmentDate!));

// debugPrint('name $patientName,  time $appointmentTime');
    return Column(
      children: [
        _buildReminderCard(patientName, appointmentTime),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAppointmentCardSection(Map<String, dynamic> data) {
    final appointment = data['appointment'];
    final patient = data['patient'];

    String? patientName = '${patient['firstName']} ${patient['lastName']}';
    String? appointmentTime = appointment['appointmentTime'];
    appointmentTime = appointmentTime?.substring(0, 5); // Remove seconds
    String? appointmentDate = appointment['appointmentDate'];
    appointmentDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(appointmentDate!));
    String? appointmentType = appointment['appointmentType'];

    return Column(
      children: [
        _buildPatientCard(
            patientName, appointmentTime, appointmentDate, appointmentType),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReminderCard(String? patientName, String? appointmentTime) {
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
                          "$appointmentTime",
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
                        MaterialPageRoute(
                            builder: (context) => ViewUserProfileScreen()),
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

  Widget _buildPatientCard(String? patientName, String? appointmentTime,
      String? appointmentDate, String? appointmentType) {
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
                          "$patientName",
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
                              "$appointmentTime",
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
                    '   $appointmentDate',
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
