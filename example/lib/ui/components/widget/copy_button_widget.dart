import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grab_tags/common/ad/interstitial_ad_widget.dart';
import 'package:grab_tags/common/payment/payment_service.dart';
import 'package:grab_tags/model/hashtag.dart';

class CopyButtonWidget extends StatefulWidget {
  final HashTag hashTag;
  const CopyButtonWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  _CopyButtonWidgetState createState() => _CopyButtonWidgetState();
}

class _CopyButtonWidgetState extends State<CopyButtonWidget> {

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
              _interstitialAdWidget.init(context, false);
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