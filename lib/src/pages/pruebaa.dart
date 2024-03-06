import 'package:flutter/material.dart';

class AnimatedContainerExample extends StatefulWidget {
  @override
  _AnimatedContainerExampleState createState() => _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isPressed = !_isPressed;
            });
          },
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: _isPressed ? 200 : 100,
            height: 50,
            color: _isPressed ? Colors.blue : Colors.red,
            child: Center(child: Text('Presiona Aquí')),
          ),
        ),
      ),
    );
  }
}