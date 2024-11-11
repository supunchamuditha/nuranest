import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  
  String? _selectedSessionTime;
  String? _appointmentMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('How another onece call you', style: _sectionTitleStyle()),
            SizedBox(height: 8),
            // Set up Free Time
            // Set up Name
            _buildTextField('Set up Name', _nameController),

            SizedBox(height: 10),
            Text('Your titles as psychologist', style: _sectionTitleStyle()),
            SizedBox(height: 8),

            // Set up Title
            _buildTextField('Set up Title', _titleController),

            SizedBox(height: 10),
            Text('Set up your work time', style: _sectionTitleStyle()),
            SizedBox(height: 8),
            // Set up Free Time
            _buildTimePicker(),

            SizedBox(height: 20),

            // Set up Single Session Time
            Text('Set up your single session time', style: _sectionTitleStyle()),
            _buildSessionTimeButtons(),

            SizedBox(height: 20),

            // Appointment Type (Physical or Online)
            Text('How you can attend appointments', style: _sectionTitleStyle()),
            _buildAppointmentTypeButtons(),

            SizedBox(height: 20),

            // Hospital input (optional)
            _buildTextField('If you are working in a hospital, add', _hospitalController),

            SizedBox(height: 20),

            // Physical location input
            _buildTextField('Physical locations', _locationController),

            SizedBox(height: 20),

            // About Section
            _buildTextField('Create about', _aboutController, maxLines: 3),

            SizedBox(height: 30),

            // Save Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   // context,
                  //   // MaterialPageRoute(
                  //   //   builder: (context) => MakePaymentPage(), // Replace with the profile screen widget
                  //   // ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB0E5FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Save Profile',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      maxLines: maxLines,
    );
  }

  // Helper function to build time pickers
  Widget _buildTimePicker() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField('Starting Time', _startTimeController),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildTextField('Ending Time', _endTimeController),
        ),
      ],
    );
  }

  // Helper function to build session time buttons
  Widget _buildSessionTimeButtons() {
    return Wrap(
      spacing: 8,
      children: ['0.5 H', '1.0 H', '2.0 H'].map((time) {
        return OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedSessionTime = time;
            });
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: _selectedSessionTime == time ? Colors.blue[100] : Colors.white,
            side: BorderSide(color: Colors.blue),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            time,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }

  // Helper function to build appointment type buttons
  Widget _buildAppointmentTypeButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _appointmentMode = 'Physical';
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: _appointmentMode == 'Physical' ? Colors.blue[100] : Colors.white,
              side: BorderSide(color: Colors.blue),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Physical',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _appointmentMode = 'Online';
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: _appointmentMode == 'Online' ? Colors.blue[100] : Colors.white,
              side: BorderSide(color: Colors.blue),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Online',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // Helper function for section title style
  TextStyle _sectionTitleStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }
}
