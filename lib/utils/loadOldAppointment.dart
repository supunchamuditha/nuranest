import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the dotenv package
import 'package:nuranest/utils/storage_helper.dart'; // Import the storage_helper.dart file
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder library
import 'package:http/http.dart' as http; // Import the http library
import 'dart:convert'; // Import for JSON decoding
import 'package:intl/intl.dart'; // Import the intl library

// Global variable to hold the doctor's full name
String? doctorFullName;
String? appointmentTime;
String? appointmentDate;
String? appointmentType;
String? specialization;

// Load appointments from the API
Future<void> loadOldAppointment() async {
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
        Uri.parse('$apiUrl/appointments/patients/$userId/upcoming');

    // // Set the _isAppointment variable to false
    // setState(() {
    //   _isAppointment = false;
    // });

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
    // Get the older appointment
    // debugPrint('resAppData first: ${resAppData['appointments'].first}');
    // Get the latest appointment
    // debugPrint('resAppData last: ${resAppData['appointments'].last}');
    // Get the oldser appointment doctor id
    // debugPrint(
    //     'resAppData older doctor id: ${resAppData['appointments'].first['doctorId']}');

    // Check if there are any appointments
    if (response.statusCode == 200 &&
        resAppData['appointments'] != null &&
        resAppData['appointments'].isNotEmpty) {
      // Get the doctorId from the last appointment
      int? doctorId = resAppData['appointments'].first['doctorId'];

      // Log the doctorId
      // debugPrint('doctorId: $doctorId');

      // Get the doctor's details from the API
      final getDoctorUrl = Uri.parse('$apiUrl/doctors/$doctorId');

      // Send a GET request to the API endpoint
      final doctorResponse = await http.get(getDoctorUrl, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      });

      // Decode the response
      final resDoctorData = json.decode(doctorResponse.body);

      // Log the response
      // debugPrint('doctorResponse: $doctorResponse');
      // Log the response status code
      // debugPrint('doctorResponse.statusCode: ${doctorResponse.statusCode}');
      // Log the response body
      // debugPrint('doctorResponse.body: ${doctorResponse.body}');
      // Log the decoded response
      // debugPrint('resDoctorData: ${resDoctorData['doctor']}');
      // Get the doctor's userId
      // debugPrint('resDoctorData id: ${resDoctorData['doctor']['userId']}');

      // Check if the response is successful
      if (doctorResponse.statusCode == 200 &&
          resDoctorData['doctor'] != null &&
          resDoctorData['doctor'].isNotEmpty) {
        // Get the doctor's userId
        int? doctorUserId = resDoctorData['doctor']['userId'];

        // Log the doctor's userId
        // debugPrint('doctorUserId: $doctorUserId');

        // Get the user's details from the API
        final getUserUrl = Uri.parse('$apiUrl/users/$doctorUserId');

        // Send a GET request to the API endpoint
        final userResponse = await http.get(getUserUrl, headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        });

        // Decode the response
        final resUserData = json.decode(userResponse.body);

        // Log the response
        // debugPrint('userResponse: $userResponse');
        // Log the response status code
        // debugPrint('userResponse.statusCode: ${userResponse.statusCode}');
        // Log the response body
        // debugPrint('userResponse.body: ${userResponse.body}');
        // Log the decoded response
        // debugPrint('resUserData: ${resUserData['user']}');
        // Get the user's fistname
        // debugPrint(
        // 'resUserData fistname: ${resUserData['user']['firstName']}');
        // Get the user's lastname
        // debugPrint(
        // 'resUserData lastname: ${resUserData['user']['lastName']}');

        // Check if the response is successful
        if (userResponse.statusCode == 200 &&
            resUserData['user'] != null &&
            resUserData['user'].isNotEmpty) {
          // Get the user's firstName
          String? doctorFirstName = resUserData['user']['firstName'];

          // Get the user's lastName
          String? doctorLastName = resUserData['user']['lastName'];

          // Log the doctor's firstName
          // debugPrint('doctorFirstName: $doctorFirstName');
          // Log the doctor's lastName
          // debugPrint('doctorLastName: $doctorLastName');

          // Check if the doctor's firstName and lastName are not null
          if (doctorFirstName != null && doctorLastName != null) {
            // Set the doctor's full name
            doctorFullName = '$doctorFirstName $doctorLastName';

            // Get the appointment time
            appointmentTime =
                resAppData['appointments'].first['appointmentTime'];
            //Remove the seconds from the time
            appointmentTime = appointmentTime?.substring(0, 5);

            // Get the appointment date
            appointmentDate =
                resAppData['appointments'].first['appointmentDate'];
            // Format the date to "DD-MM-YYYY" format
            appointmentDate = DateFormat('dd-MM-yyyy')
                .format(DateTime.parse(appointmentDate!));

            // Get the appointment type
            appointmentType =
                resAppData['appointments'].first['appointmentType'];

            // Get the specialization
            specialization = resDoctorData['doctor']['specialization'];

            // // Set the _isAppointment variable to true
            // setState(() {
            //   _isAppointment = true;
            // });

            // Log the doctor's full name
            // debugPrint('doctorFullName: $doctorFullName');
            // Log the appointment time
            // debugPrint('appointmentTime: $appointmentTime');
            // Log the appointment date
            // debugPrint('appointmentDate: $appointmentDate');
          }
        }
      }
    } else {
      // Set the _isAppointment variable to false
      // setState(() {
      //   _isAppointment = false;
      // });
    }
  } catch (error) {
    debugPrint('Error: $error');
  }
}

// Get the doctor's full name
Future<String> getDoctorFullName() async {
  await loadOldAppointment();
  return doctorFullName!;
}

// Get the appointment time
Future<String> getAppointmentTime() async {
  await loadOldAppointment();
  return appointmentTime!;
}

// Get the appointment date
Future<String> getAppointmentDate() async {
  await loadOldAppointment();
  return appointmentDate!;
}

// Get the appointment type
Future<String> getAppointmentType() async {
  await loadOldAppointment();
  return appointmentType!;
}

// Get the doctor's specialization
Future<String> getSpecialization() async {
  await loadOldAppointment();
  return specialization!;
}