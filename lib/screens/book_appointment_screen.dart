import 'package:flutter/material.dart';
import 'package:nuranest/screens/make_payment.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String? _selectedTime;
  String? _selectedAppointmentType; // "Physical" or "Online"

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
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
        _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _onTimeSlotSelected(String time) {
    setState(() {
      _selectedTime = time;
      _timeController.text = time;
    });
  }

  void _onAppointmentTypeSelected(String type) {
    setState(() {
      _selectedAppointmentType = type;
    });
  }

  void _onAppointmentLocationSelected(String type) {
    setState(() {
      _selectedAppointmentType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dr.Shanez Fernando"),
            Text("Monday to Sunday 8:00AM to 6:00PM"),
            Text("Consultation Fee for 1 hour session: 5\$"),
            SizedBox(height: 16),

            // Date input field
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: "Select Date",
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),

            // Time input field
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Select Time",
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Time slots
            Wrap(
              spacing: 8,
              children: ["7:00 AM", "8:00 AM", "10:00 AM", "12:00 PM", "2:00 PM", "5:00 PM"].map((time) {
                return OutlinedButton(
                  onPressed: () => _onTimeSlotSelected(time),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedTime == time ? Colors.blue[100] : Colors.white,
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Text(time, style: TextStyle(color: _selectedTime == time ? Colors.black : Colors.black)),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Appointment type
            Text("How you can attend appointments"),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => _onAppointmentTypeSelected("Physical"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedAppointmentType == "Physical" ? Colors.blue[100] : Colors.white,
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Text("Physical", style: TextStyle(color: _selectedAppointmentType == "Physical" ? Colors.black : Colors.black)),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _onAppointmentTypeSelected("Online"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedAppointmentType == "Online" ? Colors.blue[100] : Colors.white,
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Text("Online", style: TextStyle(color: _selectedAppointmentType == "Online" ? Colors.black : Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Information text
            Text(
              "This physical appointments for the home visits and free locations. "
              "If you want to meet doctor in a private hospital you can make an appointment "
              "via hospital websites",
            ),
            SizedBox(height: 8),
            Text("Doctor's location: No 123, Vidya mawatha Colombo 7"),
            SizedBox(height: 18),
            Text("Where you can attend appointments(Physical)"),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => _onAppointmentLocationSelected("Doctors"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedAppointmentType == "Doctors" ? Colors.blue[100] : Colors.white,
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Text("Doctor's Location", style: TextStyle(color: _selectedAppointmentType == "Doctors" ? Colors.black : Colors.black)),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _onAppointmentLocationSelected("My"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedAppointmentType == "My" ? Colors.blue[100] : Colors.white,
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Text("My Location", style: TextStyle(color: _selectedAppointmentType == "My" ? Colors.black : Colors.black)),
                ),
              ],
            ),

            // Address and message fields
            SizedBox(height: 16),
            Text("Address"),
            TextField(),
            SizedBox(height: 8),
            Text("Leave a message"),
            TextField(maxLines: 3),
            SizedBox(height: 16),

            // Book appointment button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakePaymentPage(), // Replace with the profile screen widget
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB0E5FC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Make an appointment',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
