import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/widgets/center_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool _pending = true;

  void _callBackToSetUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    PaymentService.instance.setCallBack(_callBackToSetUpdate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PaymentService.instance.restorePurchases();
    _pending = PaymentService.instance.isPurchasePending();

    List<Widget> stack = [];
    if (!_pending) {
      stack.add(
        ListView(
          children: [
            PaymentService.instance.isPro() ? Text('PRO') : Text('non-PRO'),
            _buildProductList(),
          ],
        ),
      );
    } else {
      stack.add(
        Stack(
          children: [
            const Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CenterIndicator()
            ),
          ],
        ),
      );
    }

    return Stack(children: stack);
  }

  Card _buildProductList() {
    final List<ListTile> productList = PaymentService.instance.getProducts().map((ProductDetails productDetails) {
      return ListTile(
        title: Text(productDetails.title,),
        subtitle: Text(productDetails.description,),
        trailing: TextButton(
              child: PaymentService.instance.isPro() ? Text('Purchased') : Text(productDetails.price),
              style: TextButton.styleFrom(
                backgroundColor: PaymentService.instance.isPro() ? Colors.grey : Colors.green[800],
                primary: Colors.white,
              ),
              onPressed: () {
                if (!PaymentService.instance.isPro()) {
                  PaymentService.instance.buyProduct(productDetails);
                } else {
                  launch('https://play.google.com/store/account/subscriptions');
                }
              },
            )
          );
        },
      ).toList();

    return Card(
      child: Column(children: productList)
    );
  }
}