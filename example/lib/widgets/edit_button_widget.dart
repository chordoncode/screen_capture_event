import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/ui/pages/snapshot_page.dart';

class EditButtonWidget extends StatefulWidget {
  final HashTag hashTag;

  const EditButtonWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  _EditButtonWidgetState createState() => _EditButtonWidgetState();
}

class _EditButtonWidgetState extends State<EditButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SnapShotPage()));
      },
      child: const Text(
          'EDIT',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold)
      )
    );
  }
}