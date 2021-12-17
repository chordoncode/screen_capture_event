import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewHashTagInputWidget extends StatefulWidget {

  const NewHashTagInputWidget({Key? key}) : super(key: key);

  @override
  _NewHashTagInputWidgetState createState() => _NewHashTagInputWidgetState();
}

class _NewHashTagInputWidgetState extends State<NewHashTagInputWidget> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣\\s]')),
        ],
        onChanged: (text) {
          if (text.startsWith("_")) {

          }
          _onChanged();
        },
        maxLength: 30,
        style: const TextStyle(color: Colors.blueGrey, fontSize: 15),
        controller: _inputController,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          counterStyle: TextStyle(color: Colors.white, fontSize: 8),
          errorStyle: TextStyle(color: Colors.red, fontSize: 8),
          labelText: 'Enter a new hash tag without #'
        ),
      ),
      padding: const EdgeInsets.all(10.0),
    );
  }

  void _onChanged() {
  }
}