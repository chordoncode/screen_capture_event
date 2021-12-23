import 'package:flutter/material.dart';
import 'package:grab_tags/common/ad/interstitial_ad_widget.dart';
import 'package:grab_tags/common/payment/payment_service.dart';
import 'package:grab_tags/model/hashtag.dart';
import 'package:grab_tags/ui/pages/mytag/edit_hashtag_page.dart';

class EditButtonWidget extends StatefulWidget {
  final HashTag hashTag;
  final Function callback;
  final int index;

  const EditButtonWidget({Key? key, required this.hashTag, required this.callback, required this.index}) : super(key: key);

  @override
  _EditButtonWidgetState createState() => _EditButtonWidgetState();
}

class _EditButtonWidgetState extends State<EditButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              primary: Colors.white, // background
            ),
            onPressed: () async {

              if (!PaymentService.instance.isPro()) {
                final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();
                _interstitialAdWidget.init(context, true);
              }

              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditHashTagPage(hashTagId: widget.hashTag.id)));

              setState(() {
                widget.callback();
              });
            },
            child: const Text(
                'EDIT',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 10
                )
            )
        )
    );
  }
}