import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static final Map<String, String> UNIT_ID = kReleaseMode
      ? {
    //'ios': '[YOUR iOS AD UNIT ID]',
    'android': 'ca-app-pub-9201118486372073/4333770791',
  }
      : {
    'ios': 'ca-app-pub-3940256099942544/2934735716',
    'android': 'ca-app-pub-3940256099942544/6300978111',
  };

  BannerAd banner = BannerAd(
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) {},
      onAdLoaded: (_) {},
    ),
    size: AdSize.banner,
    adUnitId: UNIT_ID[Platform.isAndroid ? 'android' : 'ios']!,
    request: const AdRequest(),
  )..load();

  @override
  void dispose() {
    banner.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AdWidget(ad: banner),
      width: banner.size.width.toDouble(),
      height: banner.size.height.toDouble(),
    );
  }
}