import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:screen_capture_event_example/common/capture/hashtag_capture_event.dart';
import 'package:screen_capture_event_example/main.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool hasActions;

  @override
  final Size preferredSize; // default is 56.0

  const CustomAppBar({Key? key, required this.hasActions}) : preferredSize = const Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {

    final ButtonStyle actionStyle =
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.green),
      title: const Text(
          'Grab Tags',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
      ),
      backgroundColor: Colors.grey.shade900,
      actions: widget.hasActions ? [
        TextButton(
          style: actionStyle,
          onPressed: () {
            setState(() {
              activated = !activated;
              activated ? _activate() : _deactivate();
            });
          },
          child: Text(
              activated ? 'Deactivate' : 'Activate',
              style: const TextStyle(color: Color.fromRGBO(250, 139, 97, 1))
          ),
        ),
      ] : [],
    );
  }

  void _activate() {
    HashTagCaptureEvent().screenCaptureEvent.watch();
    MoveToBackground.moveTaskToBack();
  }

  void _deactivate() {
    HashTagCaptureEvent().screenCaptureEvent.dispose();
  }
}