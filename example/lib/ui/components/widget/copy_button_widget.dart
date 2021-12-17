import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event_example/common/ad/interstitial_ad_widget.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';

class CopyButtonWidget extends StatefulWidget {
  final HashTag hashTag;
  const CopyButtonWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  _CopyButtonWidgetState createState() => _CopyButtonWidgetState();
}

class _CopyButtonWidgetState extends State<CopyButtonWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
            primary: Colors.blueAccent, // background
          ),
          onPressed: () {
            if (!PaymentService.instance.isPro()) {
              final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();
              _interstitialAdWidget.init(context);
            }

            _copyToClipboard().then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Copied successfully!', style: TextStyle(color: Colors.pinkAccent)),
                      duration: Duration(seconds: 2)
                  ));
            });
          },
          child: const Text(
            'COPY',
            style: TextStyle(
              color: Colors.white, fontSize: 10,
            )
          )
      )
    );
  }

  Future<void> _copyToClipboard() {
    return Clipboard.setData(ClipboardData(text: widget.hashTag.tags));
  }
}