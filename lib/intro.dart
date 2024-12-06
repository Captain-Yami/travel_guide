import 'package:flutter/material.dart';
import 'package:travel_guide/home/user/screen/login_page.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  void _navigateTologin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Travel Chronicles',
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Center(
                      child: ClipOval(
                          child: Image.asset('asset/logo3.jpg',
                              width: 300, height: 300))),
                  SizedBox(height: 20),
                  Text(
                    'Travel and explore',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'the intro about the application',
                    style: TextStyle(fontSize: 15),
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: TextButton(
                      onPressed: _navigateTologin, // Navigate to Signup page
                      child: Text('Next',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                          )),
                    ),
                  )
                ],
              ),
            )));
  }
}
