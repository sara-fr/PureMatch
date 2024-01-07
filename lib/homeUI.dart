import 'package:flutter/material.dart';

class homeUI extends StatelessWidget {
  const homeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Pure Match'),
      ),

      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Pure Match'),
            ],
          ),
        ),
      ),
    );
  }
}
