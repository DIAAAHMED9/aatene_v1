import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dialog Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: const Center(
          child: DialogButton(),
        ),
      ),
    );
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Call the function to show the dialog
      },
      child: const Text('Show Dialog'),
    );
  }

  // Function to display the dialog
}
