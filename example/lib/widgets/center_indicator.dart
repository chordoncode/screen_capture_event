import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CenterIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child:
        CircularProgressIndicator()
    );
  }

}