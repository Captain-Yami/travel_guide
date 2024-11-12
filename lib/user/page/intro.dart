import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Travel Chronicles',
          textAlign: TextAlign.center,
        ),
      ),
      body:Container(alignment: Alignment.center,
      child:Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset('asset/van.jpg',width: 350,height: 350),
            SizedBox(height: 20),
            Text('Travel and explore',textAlign: TextAlign.center, style: TextStyle(fontSize: 30),)
            ,Text('the intro about the application',style: TextStyle(fontSize: 15),)
          ],
        ),
   
   
   
    )));
  }
}
