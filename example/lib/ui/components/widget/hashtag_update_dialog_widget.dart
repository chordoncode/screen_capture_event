import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_observer/Observable.dart';

class HashTagUpdateDialogWidget extends StatefulWidget {
  final String selectedTag;
  final int index;

  const HashTagUpdateDialogWidget({Key? key, required this.selectedTag, required this.index}) : super(key: key);

  @override
  _HashTagUpdateDialogWidgetState createState() => _HashTagUpdateDialogWidgetState();

}

class _HashTagUpdateDialogWidgetState extends State<HashTagUpdateDialogWidget> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.text = widget.selectedTag;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      title: const Text(
        "Please enter a new value",
        style: TextStyle(fontSize: 15, color: Colors.white)),
      content: Padding(
        child: TextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣]')),
          ],
          onChanged: (text) {
            _onChanged(text);
          },
          maxLength: 30,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          controller: _inputController,
          decoration: const InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white, fontSize: 8),
            errorStyle: TextStyle(color: Colors.red, fontSize: 8),
            labelText: 'Update a new hash tag'
          ),
        ),
        padding: const EdgeInsets.all(10.0),
      ),
      actions: [
        SizedBox(
            height: 20,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    primary: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 12, color: Colors.blueAccent)
                )
            )
        ),
        SizedBox(
            height: 20,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  primary: Colors.blueAccent,
                ),
                onPressed: () {
                  final String updatedHashTag = '#' + _inputController.text.trim();
                  Observable.instance.notifyObservers(["_TagAreaWidgetState"], notifyName : "updated", map: {"updatedHashTag": updatedHashTag, "index": widget.index});
                  Navigator.of(context).pop();
                },
                child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 12, color: Colors.white)
                )
            )
        ),
      ],
    );
  }

  void _onChanged(String text) {
    final RegExp regexp = RegExp(r"([a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣]{1,})");
    final Iterable<RegExpMatch> allMatches = regexp.allMatches(text);

    if (allMatches.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter valid letters', style: TextStyle(color: Colors.pinkAccent)),
              duration: Duration(seconds: 2)
          )
      );
      _inputController.clear();
      return;
    }
  }
}
