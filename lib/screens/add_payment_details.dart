import 'package:flutter/material.dart';

class AddTransactionMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F0FF), // Light beige color
        elevation: 0,
        title: const Text(
          'Add Transaction Method',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // VISA Logo
            Image.asset(
              'lib/assets/images/visa.png', // Replace with the correct path to your Visa image
              height: 80,
            ),
            const SizedBox(height: 30),

            // Card Number Input
            _buildTextField('Card Number', '123 456 789 123 123'),

            const SizedBox(height: 20),

            // Name Input
            _buildTextField('Name', 'Example Name'),

            const SizedBox(height: 20),

            // CVV and Expire Date
            Row(
              children: [
                Expanded(
                  child: _buildTextField('CVV', '234'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField('Expire Date', '12/26'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Save Card Details Checkbox
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {
                    // Handle checkbox state
                  },
                  activeColor: Colors.black,
                ),
                const Text(
                  'Save Card Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Add Card Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle add card functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5ECE4), // Beige color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Center(
                child: Text(
                  'ADD CARD',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method for Input Fields
  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Color(0xFFF9F9F9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
