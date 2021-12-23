import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:grab_tags/common/ad/interstitial_ad_widget.dart';
import 'package:grab_tags/common/payment/payment_service.dart';
import 'package:grab_tags/model/hashtag.dart';
import 'package:grab_tags/repositories/hashtag_repository.dart';

class SaveButtonWidget extends StatefulWidget {
  final HashTag hashTag;

  const SaveButtonWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  _SaveButtonWidgetState createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends State<SaveButtonWidget> with Observer {
  late HashTag _hashTag;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _hashTag = widget.hashTag;
    Observable.instance.addObserver(this);
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              primary: _enabled ? Colors.white : Colors.grey,
              onPrimary: Colors.grey
            ),
            onPressed: () {
              if (_enabled) {
                if (!PaymentService.instance.isPro()) {
                  final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();
                  _interstitialAdWidget.init(context, false);
                }

                _enabled  = false;
                _update();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved successfully!', style: TextStyle(color: Colors.pinkAccent)),
                    duration: Duration(seconds: 2)
                  ));

                setState((){});
                //Navigator.pop(context);
              }
            },
            child: Text(
              'SAVE',
              style: TextStyle(
                color: _enabled ? Colors.blueAccent : Colors.white,
                fontSize: 10,)
            )
        )
    );
  }

  void _update() {
    // save widget.hashTag to local DB.
    HashTagRepository.update({
      'tags': _hashTag.tags,
      'title': _hashTag.title,
    }, widget.hashTag.id, true);
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    if (notifyName == 'titleChanged') {
      setState(() {
        _hashTag = HashTag.updateTitle(_hashTag, map!['hashTag'].title);
        _enabled = true;
      });
    } else if (notifyName == 'removed' || notifyName == 'added' || notifyName == 'updated') {
      setState(() {
        _hashTag = HashTag.updateTags(_hashTag, map!['hashTag'].tags);
        _enabled = true;
      });
    }
  }
}