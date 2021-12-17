import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/ui/pages/mytag/edit_hashtag_page.dart';
import 'package:screen_capture_event_example/ui/pages/main/layout.dart';

class EditButtonWidget extends StatefulWidget {
  final HashTag hashTag;
  final Function callback;

  const EditButtonWidget({Key? key, required this.hashTag, required this.callback}) : super(key: key);

  @override
  _EditButtonWidgetState createState() => _EditButtonWidgetState();
}

class _EditButtonWidgetState extends State<EditButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: PaymentService.instance.isPro() ? _buildForPro() : _buildForNonPro(),
    );
  }

  List<Widget> _buildForNonPro() {
    return [
      _getButtonForNonPro()
    ];
  }

  List<Widget> _buildForPro() {
    return [
      _getButtonForPro()
    ];
  }

  Widget _getButtonForNonPro() {
    return SizedBox(
        height: 20,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              primary: Colors.grey, // background
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Layout(currentIndex: 1, fromOnBoardingPage: false)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'EDIT',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10
                  )
                ),
                SizedBox(width: 2,),
                Text('PRO', style: TextStyle(fontSize: 8, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
              ],
            )

          )
        );
  }

  Widget _getButtonForPro() {
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
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditHashTagPage(hashTagId: widget.hashTag.id)));

            if (PaymentService.instance.isPro()) {
              setState(() {
                widget.callback();
              });
            }
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