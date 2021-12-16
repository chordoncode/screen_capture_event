import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';

class SaveButtonWidget extends StatefulWidget {
  final HashTag hashTag;
  final bool enabled;

  const SaveButtonWidget({Key? key, required this.hashTag, required this.enabled}) : super(key: key);

  @override
  _SaveButtonWidgetState createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends State<SaveButtonWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      return GestureDetector(
          onTap: () {
            _update();

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Saved successfully!'),
                    duration: Duration(seconds: 2)
                ));
          },
          child: const Text(
              'SAVE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)
          )
      );
    }
    return const Text(
        'SAVE',
        style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold)
    );
  }

  void _update() {
    // save widget.hashTag to local DB.
    HashTagRepository.update({
      'tags': widget.hashTag.tags
    }, widget.hashTag.id);
    Observable.instance.notifyObservers(["_HashTagComponentState"], notifyName : "saved", map: {});
  }
}