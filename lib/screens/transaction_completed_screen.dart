import 'package:flutter/material.dart';
import 'package:nuranest/screens/user_home.dart';

class TransactionCompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'), // Change the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Adjusted image position (slightly higher)
            Image.asset(
              'lib/assets/images/transaction_completed.png', // Replace with your image path
              width: 150, // Adjust the width as per your preference
              height: 150, // Adjust the height as per your preference
            ),
            SizedBox(height: 20),
            Text(
              'Booked Appointment Sucessfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
              },
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE6CDB7),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Black text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
