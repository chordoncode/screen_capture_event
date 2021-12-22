import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:neon/neon.dart';
import 'package:screen_capture_event_example/ui/pages/main/layout.dart';
import 'package:screen_capture_event_example/ui/pages/about/subscription_page.dart';

class SubscribePromotion extends StatelessWidget {
  final bool clickable;
  const SubscribePromotion({Key? key, required this.clickable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top:20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Badge(
                      shape: BadgeShape.square,
                      badgeColor: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(8),
                      badgeContent: const Text(
                          'PRO', style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
                    const SizedBox(width: 5,),
                    GestureDetector(
                        onTap: () {
                          if (clickable) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SubscriptionPage()));
                          }
                        },
                        child: Neon(
                          text: "Subscribe",
                          color: Colors.green,
                          fontSize: 20,
                          font: NeonFont.Membra,
                          flickeringText: true,
                        )
                    )
                  ]
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Neon(
                    text: "TO REMOVE",
                    color: Colors.pink,
                    fontSize: 12,
                    font: NeonFont.Beon,
                    flickeringText: true,
                  ),
                  const SizedBox(width: 5,),
                  Neon(
                    text: "ALL ADs",
                    color: Colors.pink,
                    fontSize: 12,
                    font: NeonFont.Beon,
                    flickeringText: true,
                  ),
                ],
              ),
              const SizedBox(height: 5,),
            ]
        )
    );
  }
}