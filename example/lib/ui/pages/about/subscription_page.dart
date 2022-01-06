import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:grab_tags/common/ad/banner_ad_widget.dart';
import 'package:grab_tags/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:grab_tags/common/payment/payment_service.dart';
import 'package:grab_tags/widgets/appbar/custom_app_bar.dart';
import 'package:grab_tags/widgets/button/custom_buttons.dart';
import 'package:grab_tags/widgets/center_indicator.dart';
import 'package:grab_tags/widgets/subscribe_promotion.dart';
import 'package:url_launcher/url_launcher.dart';

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
      return Scaffold(
          appBar: CustomAppBar(hasActions: false, fromOnBoardingPage: false, title: 'Subscription'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildWidget()
          )
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
      //fixme: 사업자 등록 후 주석 제거
      //widgets.add(const SizedBox(height: 20,));
      //widgets.add(const SubscribePromotion(clickable: false));
      widgets.add(const SizedBox(height: 20,));
    }
    widgets.add(
      Center(child:
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PaymentService.instance.getProducts().isNotEmpty ?
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
              ) :
            SimpleElevatedButtonWithIcon(
              label: Column(children: const [
                Text(
                  "Not Available Now",
                  style: TextStyle(fontSize: 20, color: Colors.white),),
              ]),
              iconData: PaymentService.instance.isPro() ? Icons.check : Icons.monetization_on_outlined,
              color: Colors.grey,
              onPressed: () {
              },
            )

          ]
        )
      ))
    );
    return widgets;
  }

  _buildPriceInfo() {
    final ProductDetails productDetails = PaymentService.instance.getProducts().first;
    return productDetails.price + " / 1month" ;
  }
}