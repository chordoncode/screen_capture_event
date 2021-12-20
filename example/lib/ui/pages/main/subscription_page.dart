import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:neon/neon.dart';
import 'package:screen_capture_event_example/common/ad/banner_ad_widget.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/widgets/button/custom_buttons.dart';
import 'package:screen_capture_event_example/widgets/center_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'layout.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends LifecycleWatcherState<SubscriptionPage> {
  bool _pending = true;

  void _callBackToSetUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PaymentService.instance.setCallBack(_callBackToSetUpdate);
    PaymentService.instance.restorePurchases();
    _pending = PaymentService.instance.isPurchasePending();

    if (!_pending) {
      return Column(
        /*
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/benefit.jpeg"),
            fit: BoxFit.contain,
          ),
        ),
         */
        children: _buildWidget()/* add child content here */,
      );
    } else {
      return Stack(
        children: [
          const Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
              child: CenterIndicator()
          ),
        ],
      );
    }
  }

  List<Widget> _buildWidget() {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 10,));

    if (!PaymentService.instance.isPro()) {
      widgets.add(const BannerAdWidget());
      widgets.add(
        Padding(
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
                    badgeContent: const Text('PRO', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                  const SizedBox(width: 5,),
                  Neon(
                    text: "Subscribe",
                    color: Colors.green,
                    fontSize: 20,
                    font: NeonFont.Membra,
                    flickeringText: true,
                  )
                ]
              ),
            ]
          )
        )
      );
    }
    widgets.add(const SizedBox(height: 10,));
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 10, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleElevatedButtonWithIcon(
              label: Column(children: [
                Text(
                  PaymentService.instance.isPro() ? "Already subscribed" : "Subscribe",
                  style: const TextStyle(fontSize: 20, color: Colors.white),),
                const SizedBox(height: 5,),
                Text(
                  PaymentService.instance.isPro() ? "Manage my subscription" : _buildPriceInfo(),
                  style: const TextStyle(fontSize: 15, color: Colors.white),)
              ]),
              iconData: PaymentService.instance.isPro() ? Icons.check : Icons.monetization_on_outlined,
              color: PaymentService.instance.isPro() ? Colors.blueAccent : Colors.greenAccent,
              onPressed: () {
                if (PaymentService.instance.isPro()) {
                  launch('https://play.google.com/store/account/subscriptions');
                } else {
                  PaymentService.instance.buyProduct(PaymentService.instance.getProducts().first);
                }
              },
            ),
          ]
        )
      )
    );

    final List<dynamic> subMenus = [
      Neon(
        text: "Features",
        color: Colors.pink,
        fontSize: 18,
        font: NeonFont.Beon,
        flickeringText: true,
      ),
      const Text("Remove all Ads", style: TextStyle(color: Colors.white),),
      const Text("Grab tags from other apps besides Instagram", style: TextStyle(color: Colors.white),),
      const Text("Copy & Manage tags without limitations", style: TextStyle(color: Colors.white),),
      const Text("Use new features without additional payment", style: TextStyle(color: Colors.white),),
    ];
    widgets.add(
      Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: subMenus.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return subMenus[index];
            } else {
              return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                      children: [
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                        const SizedBox(width: 5,),
                        subMenus[index]
                      ]
                  )
              );
            }
          },
          separatorBuilder: (context, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: Divider(thickness: 0, color: Colors.grey)
              );
            } else {
              return const Divider(thickness: 0, color: Colors.transparent);
            }
          },
        )
      )
    );
    return widgets;
  }

  _buildPriceInfo() {
    final ProductDetails productDetails = PaymentService.instance.getProducts().first;
    return productDetails.price + " / 1month" ;
  }
}

class SubscriptionBenefit extends StatelessWidget {
  final Text text;

  const SubscriptionBenefit({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PaymentService.instance.isPro() ?
          const Icon(Icons.check_box_outlined, color: Colors.blueGrey,) :
          const Icon(Icons.check_box_outline_blank_outlined, color: Colors.blueGrey,),
        const SizedBox(width: 5,),
        text
      ],
    );
  }
}