import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/util/time_utils.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';

class TagDateWidget extends StatelessWidget {
  final HashTag hashTag;

  const TagDateWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          TimeUtils.toFormattedString(hashTag.modifiedDateTime, 'yyyy-MM-dd hh:mm'),
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 10,
          ),
        )
      ],
    );
  }
}