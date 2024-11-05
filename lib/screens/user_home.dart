// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//       theme: ThemeData(fontFamily: 'Poppins'),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F0FF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),

//               // Greeting Text
//               Text(
//                 "Hey, Name 👋",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "How are you feeling today?",
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black54,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Mood Selector
//               Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Icon(Icons.sentiment_very_dissatisfied, color: Colors.grey),
//                     Icon(Icons.sentiment_dissatisfied, color: Colors.grey),
//                     Icon(Icons.sentiment_neutral, color: Colors.grey),
//                     Icon(Icons.sentiment_satisfied, color: Colors.yellow),
//                     Icon(Icons.sentiment_very_satisfied, color: Colors.grey),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Reminder Card
//               ReminderCard(
//                 icon: Icons.person,
//                 message: "Im Here To Remind you,",
//                 subMessage: "You have a session with Mr.Fernando today.",
//                 buttonText: "Go to my Appointments",
//               ),
//               const SizedBox(height: 10),

//               // Appointment Card
//               ReminderCard(
//                 icon: Icons.person,
//                 message: "Meet your psychologist",
//                 subMessage: "",
//                 buttonText: "Go to Make appointment",
//               ),
//               const SizedBox(height: 10),

//               // Article Card
//               ArticleCard(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Color(0xFFF5E0D6),
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.black54,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
//         ],
//       ),
//     );
//   }
// }

// // Reminder Card Widget
// class ReminderCard extends StatelessWidget {
//   final IconData icon;
//   final String message;
//   final String subMessage;
//   final String buttonText;

//   const ReminderCard({
//     required this.icon,
//     required this.message,
//     required this.subMessage,
//     required this.buttonText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Color(0xFFF5E0D6),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(icon, color: Colors.orangeAccent),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       message,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     if (subMessage.isNotEmpty)
//                       Text(
//                         subMessage,
//                         style: TextStyle(fontSize: 12, color: Colors.black54),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 buttonText,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               CircleAvatar(
//                 radius: 15,
//                 backgroundColor: Colors.yellow,
//                 child: Icon(Icons.play_arrow, color: Colors.black),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Article Card Widget
// class ArticleCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Color(0xFFF5E0D6),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Like to Read Articles?",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Go to articles",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     CircleAvatar(
//                       radius: 15,
//                       backgroundColor: Colors.yellow,
//                       child: Icon(Icons.play_arrow, color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: Colors.white,
//             backgroundImage: AssetImage('lib/assets/images/article_image.png'), // Update with your image path
//           ),
//         ],
//       ),
//     );
//   }
// }
