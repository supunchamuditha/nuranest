import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<Map<String, dynamic>> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final userData = prefs.getString('user');
  return userData != null ? jsonDecode(userData) : {};
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
