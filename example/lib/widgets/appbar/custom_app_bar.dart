import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:grab_hashtag/common/ad/interstitial_ad_widget.dart';
import 'package:grab_hashtag/common/capture/hashtag_capture_event.dart';
import 'package:grab_hashtag/common/notification/app_notification.dart';
import 'package:grab_hashtag/common/payment/payment_service.dart';
import 'package:grab_hashtag/common/storage/shared_storage.dart';
import 'package:grab_hashtag/common/storage/shared_storage_key.dart';
import 'package:grab_hashtag/main.dart';

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

    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.green),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/app_icon.png', width: 25),
            const SizedBox(width: 5,),
            Text(
              widget.title != null ? widget.title! : 'Grab Hashtag',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          ]
      ),
      backgroundColor: Colors.grey.shade900,
      actions: widget.hasActions ? buildActions() : [],
    );
  }

  List<Widget> buildActions() {
    final ButtonStyle actionStyle = TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    List<Widget> actions = [];

    if (!activated) {
      actions.add(
        Badge(
          padding: const EdgeInsets.all(8),
          position: BadgePosition.topStart(top: 0),
          animationDuration: const Duration(milliseconds: 500),
          animationType: BadgeAnimationType.scale,
          badgeContent: const Text(
              '!',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, )
          ),
          badgeColor: Colors.pinkAccent,
          child: TextButton(
            style: actionStyle,
            onPressed: () {
              setState(() {
                activated = !activated;
                _activate();
              });
            },
            child: const Text(
              'Activate',
              style: TextStyle(color: Color.fromRGBO(250, 139, 97, 1))
            ),
          )
        )
      );
    } else {
      actions.add(
        TextButton(
          style: actionStyle,
          onPressed: () {
            setState(() {
              activated = !activated;
              _deactivate();
            });
          },
          child: const Text(
            'Deactivate',
            style: TextStyle(color: Color.fromRGBO(250, 139, 97, 1))
          ),
        )
      );
    }
    return actions;
  }

  void _activate() {
    AppNotification().showNotification(-1, 'Grab Hashtag', 'Grab Hashtag has been activated.').then((value) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        AppNotification().cancelAllNotifications();
      });
    });
    HashTagCaptureEvent().screenCaptureEvent.watch();

    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("Grab Hashtag", style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
        content: const Text("Capture a screenshot to grab hashtag!", style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Stay here"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: const Text("Move to grab hashtags"),
            onPressed: () {
              Navigator.pop(context);
              MoveToBackground.moveTaskToBack();
            },
          ),
        ],
      ),
    );
    //MoveToBackground.moveTaskToBack();
  }

  void _deactivate() {
    //AppNotification().showNotification(-1, 'Grab Hashtag', 'Grab Tags has been deactivated.');
    AppNotification().cancelAllNotifications();
    HashTagCaptureEvent().screenCaptureEvent.dispose();

    if (!PaymentService.instance.isPro()) {
      final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();
      _interstitialAdWidget.init(context, false);
    }
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