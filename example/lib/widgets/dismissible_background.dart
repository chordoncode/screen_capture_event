import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {
  final String? message;

  const DismissBackground({Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(3),
    color: Colors.grey.shade900,
    child: Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.delete, color: Colors.white),
          Text(message??"", style: const TextStyle(color: Colors.white)),
          const Icon(Icons.delete, color: Colors.white),
        ],
      )
    )

  );

}