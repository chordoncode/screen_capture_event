import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';

class CopyButtonWidget extends StatelessWidget {
  final HashTag hashTag;

  const CopyButtonWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _copyToClipboard().then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Copied successfully!'),
                    duration: Duration(seconds: 2)
                ));
          });
        },
        child: const Text(
            'COPY',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)
        )
    );
  }

  Future<void> _copyToClipboard() {
    return Clipboard.setData(ClipboardData(text: hashTag.tags));
  }
}