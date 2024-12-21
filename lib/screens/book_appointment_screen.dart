import 'package:flutter/material.dart'; // Import the material package
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv package
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder library
import 'package:nuranest/screens/make_payment.dart'; // Import the make_payment.dart file
import 'package:nuranest/utils/appointmentValidators.dart'; // Import the appointmentValidators.dart file
import 'package:nuranest/utils/storage_helper.dart'; // Import the storage_helper.dart file
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import the http library
// import 'package:intl/intl.dart'; // Import the intl library

class BookAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> doctorDetails;

  BookAppointmentPage({required this.doctorDetails, Key? key})
      : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String? _selectedTime;
  String? _selectedAppointmentType; // "Physical" or "Online"
  String? _selectedAppointmentLocation; // "Doctors" or "My"

  String? doctorFullName;
  String? availableDays;
  String? consultationFee;
  String? doctorLocation;
  int? docId;

  void initState() {
    super.initState();
    _loadDoctorDetails();
  }

  Future<void> _loadDoctorDetails() async {
    setState(() {
      // Extract doctor details from widget property
      final Map<String, dynamic> doctorDetails = widget.doctorDetails;

      // Log doctor details widget property
      debugPrint("Doctor details: $doctorDetails");

      // Set doctor full name
      doctorFullName = doctorDetails['doctorFullName'];

      // Extract doctor more details
      final doctorMoreDetails = doctorDetails['doctorDeails']['DoctorDetails'];

      // Set doctor id
      docId = doctorMoreDetails['id'];

      // Set doctor available days
      availableDays =
          "${doctorMoreDetails['availableDays'].first} to ${doctorMoreDetails['availableDays'].last}";

      // Set doctor consultation fee
      consultationFee = doctorMoreDetails['consultationFee'];

      // Set doctor location
      doctorLocation = doctorMoreDetails['workplace'];

      // Log doctor id
      // debugPrint("Doctor id: $doctorId");
      // Log doctor full name
      // debugPrint("Doctor full name: $doctorFullName");
      //Log doctor more details
      // debugPrint("Doctor more details: $doctorMoreDetails");
      // Log doctor available days
      // debugPrint("Doctor available days: $availableDays");
      // Log doctor consultation fee
      // debugPrint("Doctor consultation fee: $consultationFee");
      // Log doctor location
      // debugPrint("Doctor location: $doctorLocation");
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  void _onTimeSlotSelected(String time) {
    setState(() {
      _selectedTime = time;
      timeController.text = time;
    });
  }

  void _onAppointmentTypeSelected(String type) {
    setState(() {
      _selectedAppointmentType = type;
      // Reset location selection if switching appointment type
      if (type == "Online") _selectedAppointmentLocation = null;
    });
  }

  void _onAppointmentLocationSelected(String location) {
    if (_selectedAppointmentType == "Physical") {
      setState(() {
        _selectedAppointmentLocation = location;
      });
    }
  }

  // Define the loading state
  bool isLoading = false;

  Future<void> _bookAppointment() async {
    try {
      // Get the user's token from SharedPreferences
      String? token = await getToken();

      if (token == null) {
        throw Exception("Token not found");
      }

      // Decode the token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Extract the user ID (or any other field you need)
      int? userId = decodedToken['id'];

      // Get the user input
      final appointmentDate = dateController.text;
      String? appointmentTime = timeController.text;
      final appointmentType = _selectedAppointmentType;
      final appointmentLocation = _selectedAppointmentLocation;
      final additionalInfo = messageController.text;
      final patientId = userId;
      final doctorId = docId;

      // Convert appointment type to lowercase
      final appointmentTypeLowerCase = appointmentType?.toLowerCase();

      // set the _isLoading variable to true
      setState(() {
        isLoading = true;
      });

      // debugPrint(
          // 'Appointment Date: $appointmentDate, Appointment Time: $appointmentTime, Appointment Type: $appointmentType, Appointment Location: $appointmentLocation, Additional Info: $additionalInfo, Patient ID: $patientId, Doctor ID: $doctorId');

      // Get the API URL from the environment
      final apiUrl = dotenv.env['API_URL'];

      // Define the register URL
      final appointmentUrl = '$apiUrl/appointments';

      // Send a POST request to the API
      final response = await http.post(Uri.parse(appointmentUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(
            {
              'appointmentDate': appointmentDate,
              'appointmentTime': appointmentTime,
              'appointmentType': appointmentTypeLowerCase,
              'appointmentLocation': appointmentLocation,
              'additionalInfo': additionalInfo,
              'patientId': patientId,
              'doctorId': doctorId,
            },
          ));

      // Decode the response
      // final resData = json.decode(response.body);

      // Log the response
      // debugPrint('response: $response');
      // Log the response status code
      // debugPrint('response.statusCode: ${response.statusCode}');
      // Log the response body
      // debugPrint('response.body: ${response.body}');
      // Log the decoded response
      // debugPrint('resData: $resData');

      // Check if the response status code is 201
      if (response.statusCode == 201) {
        // Show a success message
        _showMessage('Appointment booked successfully');

        // Navigate to the MakePaymentPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MakePaymentPage(
              consultationFee: consultationFee,
            ),
          ),
        );

        // Clear all inputs and selectors
        dateController.clear();
        timeController.clear();
        addressController.clear();
        messageController.clear();
        setState(() {
          _selectedTime = null;
          _selectedAppointmentType = null;
          _selectedAppointmentLocation = null;
        });
      } else {
        // Show an error message
        _showMessage('An error occurred. Please try again');
      }
    } catch (error) {
      debugPrint('Error: $error');
      _showMessage('An error occurred. Please try again');
    } finally {
      // Set the _isLoading variable to false
      setState(() {
        isLoading = false;
      });
    }
  }

  // Define the _showMessage method
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Details
              Text(
                "Dr. ${doctorFullName ?? 'Unknown Doctor'}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("$availableDays, 8:00 AM to 6:00 PM"),
              Text("Consultation Fee for 1-hour session: Rs. $consultationFee"),
              const SizedBox(height: 16),

              // Date input field
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      hintText: "Select Date",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (!validateDate(value)) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Time input field
              TextFormField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select Time",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (!validateTime(value)) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Time slots
              Wrap(
                spacing: 8,
                children: [
                  "07:00",
                  "8:00",
                  "10:00",
                  "12:00",
                  "14:00",
                  "17:00"
                ].map((time) {
                  return OutlinedButton(
                    onPressed: () => _onTimeSlotSelected(time),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _selectedTime == time
                          ? Colors.blue[100]
                          : Colors.white,
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                          color: _selectedTime == time
                              ? Colors.black
                              : Colors.black),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Appointment type
              const Text("How you can attend appointments"),
              Row(
                children: [
                  _buildOutlinedButton(
                    label: "Physical",
                    isSelected: _selectedAppointmentType == "Physical",
                    onPressed: () => _onAppointmentTypeSelected("Physical"),
                  ),
                  const SizedBox(width: 8),
                  _buildOutlinedButton(
                    label: "Online",
                    isSelected: _selectedAppointmentType == "Online",
                    onPressed: () => _onAppointmentTypeSelected("Online"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Information text
              const Text(
                "Physical appointments are for home visits and free locations. "
                "If you want to meet the doctor in a private hospital, you can make an appointment via hospital websites.",
              ),
              const SizedBox(height: 8),
              Text("Doctor's location: $doctorLocation"),
              const SizedBox(height: 18),

              // Appointment location
              const Text("Where you can attend appointments (Physical)"),
              Row(
                children: [
                  _buildOutlinedButton(
                    label: "Doctor's Location",
                    isSelected: _selectedAppointmentLocation == "Doctors",
                    onPressed: _selectedAppointmentType == "Physical"
                        ? () => _onAppointmentLocationSelected("Doctors")
                        : null,
                  ),
                  const SizedBox(width: 8),
                  _buildOutlinedButton(
                    label: "My Location",
                    isSelected: _selectedAppointmentLocation == "My",
                    onPressed: _selectedAppointmentType == "Physical"
                        ? () => _onAppointmentLocationSelected("My")
                        : null,
                  ),
                ],
              ),

              // Address and message fields
              const SizedBox(height: 16),
              const Text("Address"),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Enter your address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (!validateAddress(value)) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              const Text("Leave a message"),
              TextFormField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter your message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (!validateMessage(value)) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Book appointment button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Call the _bookAppointment method
                      _bookAppointment();

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MakePaymentPage(),
                      //   ),
                      // );

                      // // Clear all inputs and selectors
                      // dateController.clear();
                      // timeController.clear();
                      // addressController.clear();
                      // messageController.clear();
                      // setState(() {
                      //   _selectedTime = null;
                      //   _selectedAppointmentType = null;
                      //   _selectedAppointmentLocation = null;
                      // });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0E5FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'Make an appointment',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build buttons
  Widget _buildOutlinedButton({
    required String label,
    required bool isSelected,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[100] : Colors.white,
        side: const BorderSide(color: Colors.black),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: onPressed != null ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
