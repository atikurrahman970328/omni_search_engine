import 'package:flutter/material.dart';

class MainDashboardView extends StatelessWidget {
  const MainDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Omni Search Engine'),
      ),
      body: const Center(
        child: Text('Welcome to Omni Search Engine'),
      ),
    );
  }
}
