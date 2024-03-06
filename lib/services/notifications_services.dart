import 'package:flutter/material.dart';

class NotificationsServices {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 10.0),
            Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 4, 13, 65),
      duration: Duration(seconds: 3),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
