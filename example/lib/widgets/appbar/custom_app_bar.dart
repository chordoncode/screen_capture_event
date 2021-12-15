import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:screen_capture_event_example/common/capture/hashtag_capture_event.dart';
import 'package:screen_capture_event_example/common/notification/app_notification.dart';
import 'package:screen_capture_event_example/common/storage/shared_storage.dart';
import 'package:screen_capture_event_example/common/storage/shared_storage_key.dart';
import 'package:screen_capture_event_example/main.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool hasActions;
  final bool fromOnBoardingPage;
  String? title;

  @override
  final Size preferredSize; // default is 56.0

  CustomAppBar({Key? key, required this.hasActions, required this.fromOnBoardingPage, this.title}) : preferredSize = const Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _executeAfterWholeBuildProcess(context));

    final ButtonStyle actionStyle =
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.green),
      title: Text(
          widget.title != null ? widget.title! : 'Grab Tags',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
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
    AppNotification().showNotification(-1, 'Grab tags', 'Grab tags has been activated.');
    HashTagCaptureEvent().screenCaptureEvent.watch();
    MoveToBackground.moveTaskToBack();
  }

  void _deactivate() {
    AppNotification().showNotification(-1, 'Grab tags', 'Grab tags has been deactivated.');
    HashTagCaptureEvent().screenCaptureEvent.dispose();
  }

  _executeAfterWholeBuildProcess(BuildContext context) {
    bool? doneOnBoarding = SharedStorage.read(SharedStorageKey.doneOnBoarding);
    doneOnBoarding = doneOnBoarding?? false;

    if (!doneOnBoarding) {
      SharedStorage.write(SharedStorageKey.doneOnBoarding, true);

      setState(() {
        activated = true;
        _activate();
      });
    }
  }
}