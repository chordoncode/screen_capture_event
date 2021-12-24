import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_observer/Observable.dart';

class NewHashTagInputWidget extends StatefulWidget {

  const NewHashTagInputWidget({Key? key}) : super(key: key);

  @override
  _NewHashTagInputWidgetState createState() => _NewHashTagInputWidgetState();
}

class _NewHashTagInputWidgetState extends State<NewHashTagInputWidget> {
  final TextEditingController _inputController = TextEditingController();

  String getValue() {
    return _inputController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣\\s]')),
        ],
        onChanged: (text) {
          _onChanged(text);
        },
        maxLength: 30,
        style: const TextStyle(color: Colors.blueGrey, fontSize: 15),
        controller: _inputController,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          counterStyle: TextStyle(color: Colors.white, fontSize: 8),
          errorStyle: TextStyle(color: Colors.red, fontSize: 8),
          labelText: 'Enter a new hash tag without # and space'
        ),
      ),
      padding: const EdgeInsets.all(10.0),
    );
  }

  void _onChanged(String text) {
    final RegExp regexp = RegExp(r"[a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣]{1,}");
    final Iterable<RegExpMatch> allMatches = regexp.allMatches(text);

    if ((text.length == 1 && text.endsWith(" ")) || allMatches.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter valid letters', style: TextStyle(color: Colors.pinkAccent)),
              duration: Duration(seconds: 2)
          )
      );
      _inputController.clear();
      return;
    }

    if (text.endsWith(" ")) {
      final String newHashTag = '#' + _inputController.text.trim();
      Observable.instance.notifyObservers(["_TagAreaWidgetState"], notifyName : "added", map: {"newHashTag": newHashTag});
      _inputController.clear();
    }
  }
}