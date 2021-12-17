import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';

class TitleInputWidget extends StatefulWidget {
  final HashTag hashTag;

  const TitleInputWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  _TitleInputWidgetState createState() => _TitleInputWidgetState();
}

class _TitleInputWidgetState extends State<TitleInputWidget> {
  final TextEditingController _inputController = TextEditingController();
  late HashTag _hashTag;

  @override
  void initState() {
    super.initState();
    _hashTag = widget.hashTag;
    _inputController.text = _hashTag.title;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      child: TextField(
        onChanged: (text) {
          _onChanged();
        },
        maxLength: 30,
        style: const TextStyle(color: Colors.blueGrey, fontSize: 15),
        controller: _inputController,
        decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white, fontSize: 8),
            errorStyle: TextStyle(color: Colors.red, fontSize: 8),
            labelText: 'Enter a title'
        ),
      ),
      padding: const EdgeInsets.all(20.0),
    );
  }

  void _onChanged() {
    final HashTag newHashTag = HashTag.updateTitle(_hashTag, _inputController.text);
    Observable.instance.notifyObservers(["_SaveButtonWidgetState"], notifyName : "titleChanged", map: {"hashTag": newHashTag});
  }
}