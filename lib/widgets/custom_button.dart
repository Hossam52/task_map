import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.onPressed, required this.content})
      : super(key: key);
  final VoidCallback onPressed;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            content,
            textAlign: TextAlign.center,
          )),
    );
  }
}
