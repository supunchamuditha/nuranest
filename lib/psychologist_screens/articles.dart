import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PsychologistArticle extends StatefulWidget {
  const PsychologistArticle({super.key});

  @override
  State<PsychologistArticle> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<PsychologistArticle> {
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