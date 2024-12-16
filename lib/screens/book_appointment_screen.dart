import 'package:flutter/material.dart';
import 'package:nuranest/screens/make_payment.dart';
import 'package:nuranest/utils/appointmentValidators.dart';

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
  int? doctorId;

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
      doctorId = doctorMoreDetails['id'];

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
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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
                  "7:00 AM",
                  "8:00 AM",
                  "10:00 AM",
                  "12:00 PM",
                  "2:00 PM",
                  "5:00 PM"
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MakePaymentPage(),
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
