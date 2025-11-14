import 'package:bidaya/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BidayaApp());
}

class BidayaApp extends StatelessWidget {
  const BidayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bidaya',
      theme: ThemeData(fontFamily: 'Cairo', useMaterial3: true),
      home: const HomePage(),
    );
  }
}
