import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //code can be added from here
    return const Center(
      child: Text('Home Page',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}
