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
      Badge(
        shape: BadgeShape.square,
        badgeColor: Colors.pinkAccent,
        borderRadius: BorderRadius.circular(8),
        badgeContent: const Text(
            'PRO', style: TextStyle(fontSize: 6, color: Colors.white)),
      ),
      const SizedBox(width: 2,),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Layout(currentIndex: 1, fromOnBoardingPage: false)));
        },
        child: const Text(
          'EDIT',
          style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold
          )
        ),
      )
    ];
  }

  List<Widget> _buildForPro() {
    return [
      GestureDetector(
          onTap: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditHashTagPage(hashTagId: widget.hashTag.id)));
            setState(() {
              widget.callback();
            });
          },
          child: const Text(
              'EDIT',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              )
          )
      ),
    ];
  }
}