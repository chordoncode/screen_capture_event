import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  final String? message;

  DismissBackground({
    this.message,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(3),
    color: Colors.purple,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.delete),
        Text(message??""),
        Icon(Icons.delete),
      ],
    )
  );

}