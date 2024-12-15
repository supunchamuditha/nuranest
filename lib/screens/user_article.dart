// import 'package:flutter/material.dart';
// import 'package:nuranest/screens/user_article_view.dart';

// class UserArticle extends StatefulWidget {
//   const UserArticle({Key? key}) : super(key: key);

//   @override
//   _UserArticleState createState() => _UserArticleState();
// }

// class _UserArticleState extends State<UserArticle> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Articles",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       backgroundColor: const Color(0xFFF5F0FF),
//       body: const HomeScreenContent(), // Display the HomeScreen content
//     );
//   }
// }

// class HomeScreenContent extends StatefulWidget {
//   const HomeScreenContent({Key? key}) : super(key: key);

//   @override
//   _HomeScreenContentState createState() => _HomeScreenContentState();
// }

// class _HomeScreenContentState extends State<HomeScreenContent> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSearchBar(),
//           const SizedBox(height: 20),
//           _buildReadArticleCard(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: TextField(
//         decoration: const InputDecoration(
//           icon: Icon(Icons.search, color: Colors.grey),
//           hintText: "Search",
//           hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
//           border: InputBorder.none,
//         ),
//         style: const TextStyle(color: Colors.black),
//       ),
//     );
//   }

//   Widget _buildReadArticleCard(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30),
//       ),
//       color: const Color(0xFFF5EDD3),
//       child: Container(
//         padding: const EdgeInsets.all(0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           image: const DecorationImage(
//             image: AssetImage('lib/assets/images/read_articles.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 155),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFAF9F5).withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   RichText(
//                     text: const TextSpan(
//                       text: 'View ',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'article',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const UserArticleView()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.all(0),
//                       shape: const CircleBorder(),
//                       backgroundColor: const Color(0xFFFFE86C),
//                     ),
//                     child: const Icon(
//                       Icons.play_arrow,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class UserArticle extends StatefulWidget {
  const UserArticle({super.key});

  @override
  State<UserArticle> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<UserArticle> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://syncraft.dev/'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}