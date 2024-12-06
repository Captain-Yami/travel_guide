import 'package:flutter/material.dart';

class MaleUsers extends StatefulWidget {
  const MaleUsers({super.key});

  @override
  State<MaleUsers> createState() => _MaleUsersState();
}

class _MaleUsersState extends State<MaleUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Male Users'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: const Text('List of Male Users'),
      ),
    );
  }
}