import 'package:flutter/material.dart';

class TailoringScreen extends StatelessWidget {
  const TailoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tailoring")),
      body: const Center(child: Text("Tailoring Service Page")),
    );
  }
}
