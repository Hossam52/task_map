import 'package:flutter/material.dart';
import 'package:map_task/views/map_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange,
          accentColor: Colors.grey,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade900)))),
      home: MapScreen(),
    );
  }
}
