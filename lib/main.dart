import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widgets Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              
              Container(
                color: Colors.lightGreen,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Hello World',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              
              
              
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 150, height: 150, color: Colors.lightGreenAccent),
                  const Text(
                    'Hola',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 8),
                  Text('Bienvenidos'),
                ],
              ),

              const SizedBox(height: 30),


            ],
          ),
        ),
      ),
    );
  }
}
