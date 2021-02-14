import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          child: Center(
            child: Column(
              children: [
                Text('Login'),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/app');
                  },
                ),
                ElevatedButton(
                  child: Text('Signup'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                )
              ],
            ),
          )
      ),
    );
  }
}