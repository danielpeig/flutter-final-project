import 'package:flutter/material.dart';

class restaurant extends StatefulWidget {
  const restaurant({super.key});

  @override
  State<restaurant> createState() => _restaurantState();
}

class _restaurantState extends State<restaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Restaurant Details")),
      body: const Center(child: Text("Welcome to the details page!")),
    );
  }
}
