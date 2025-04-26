import 'package:flutter/material.dart';
import 'package:servicehub/welcome.dart';
import 'package:servicehub/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API service with local IP address
  // Replace 192.168.1.5 with your actual computer's IP address
  ApiService.initialize(
    baseUrl: 'http://192.168.1.5:5000',
  );

  runApp(ServiceHubApp());
}

class ServiceHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiceHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(customerName: 'Guest'),
    );
  }
}
