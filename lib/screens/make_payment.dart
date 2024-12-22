import 'package:flutter/material.dart';
import 'package:nuranest/screens/transaction_completed_screen.dart';

class MakePaymentPage extends StatefulWidget {
  final String? consultationFee;
  @override
  _MakePaymentPageState createState() => _MakePaymentPageState();

  MakePaymentPage({Key? key, this.consultationFee}) : super(key: key);
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  bool isCheckboxChecked = false;
  bool isVisaSelected = false; // Track whether Visa is selected
  bool isPaymentMethodSelected =
      false; // Track if any payment method is selected
  String? consultationFee;
  int? totalFee;

  @override
  void initState() {
    super.initState();
    consultationFee = widget.consultationFee;
    calculateTotalFee(consultationFee!, 250.00);
  }

  void calculateTotalFee(String consultationFee, double taxFee) {
    int consultationFeeInt = int.tryParse(consultationFee) ?? 0;
    debugPrint("Consultation Fee: $consultationFeeInt");
    totalFee = consultationFeeInt + taxFee.toInt();
    debugPrint("Total Fee: $totalFee");
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
            Text(
              'Make Payment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Consultation Fee: Rs. $consultationFee"),
                  Text("Tax Fee: Rs. 250.00"),
                  Text(
                    "Total Fee: Rs. $totalFee",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Payment method selection
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Method",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      Card(
                        color: isVisaSelected
                            ? Colors.blue[50]
                            : Colors.white, // Change color when selected
                        child: ListTile(
                          leading: Image.asset('lib/assets/images/visa.png',
                              width: 70, height: 70),
                          title: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "1234 5678 9123 4567\n",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: "Example Name\n",
                                  style: TextStyle(fontSize: 12),
                                ),
                                TextSpan(
                                  text: "12/26",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                          trailing: isVisaSelected
                              ? Icon(Icons.check,
                                  color: Colors
                                      .green) // Show checkmark when selected
                              : null,
                          onTap: () {
                            setState(() {
                              isVisaSelected =
                                  !isVisaSelected; // Toggle the Visa selection
                              isPaymentMethodSelected =
                                  isVisaSelected; // Update the payment method selected status
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isCheckboxChecked &&
                            isPaymentMethodSelected, // Disable checkbox if no payment method is selected
                        onChanged: isPaymentMethodSelected
                            ? (value) {
                                setState(() {
                                  isCheckboxChecked = value!;
                                });
                              }
                            : null, // Only allow checkbox change when a payment method is selected
                      ),
                      Expanded(
                        child: Text(
                          "By booking this appointment, you agree to the fee and payment terms.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Fade the "Make Payment" button based on both conditions
                  AnimatedOpacity(
                    opacity: (isCheckboxChecked && isPaymentMethodSelected)
                        ? 1.0
                        : 0.3,
                    duration: Duration(seconds: 1),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (isCheckboxChecked && isPaymentMethodSelected)
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionCompletedPage()),
                                    );
                                  }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE6CDB7),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Make Payment',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Bank deposit details
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BANK DEPOSIT image at the top
                  Row(
                    children: [
                      Image.asset(
                        'lib/assets/images/bank_deposit.png',
                        width: 80,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "80023167391",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Commercial Bank : Kurunegala"),
                          Text("Nura Nest Healthcare"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upload Receipt",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Handle upload action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB0E5FC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: Text(
                          "UPLOAD",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE6CDB7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
