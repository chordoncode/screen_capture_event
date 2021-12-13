import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event_example/common/ad/interstitial_ad_page.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';

class CopyButtonWidget extends StatefulWidget {
  final HashTag hashTag;
  const CopyButtonWidget({Key? key, required this.hashTag}) : super(key: key);

  @override
  _CopyButtonWidgetState createState() => _CopyButtonWidgetState();
}

class _CopyButtonWidgetState extends State<CopyButtonWidget> {
  final InterstitialAdPage _interstitialAdPage = InterstitialAdPage();

  @override
  void initState() {
    super.initState();
    _interstitialAdPage.init();
  }

  @override
  void dispose() {
    _interstitialAdPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _copyToClipboard().then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Copied successfully!'),
                    duration: Duration(seconds: 2)
                ));
          });
        },
        child: const Text(
            'COPY',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)
        )
    );
  }

  Future<void> _copyToClipboard() {
    _interstitialAdPage.showInterstitialAd();
    return Clipboard.setData(ClipboardData(text: widget.hashTag.tags));
  }
}