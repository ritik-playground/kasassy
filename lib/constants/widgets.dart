import 'package:flutter/material.dart';

class Progress {
  static Container linearProgress() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: const LinearProgressIndicator(
        backgroundColor: Colors.red,
        valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
      ),
    );
  }

  static Container circularProgress() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10),
      child: const CircularProgressIndicator(
        strokeWidth: 1,
        valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
      ),
    );
  }
}
