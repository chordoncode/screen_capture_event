import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adfit/flutter_adfit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static bool kReleaseMode = true;
  static final Map<String, String> ADMOB = kReleaseMode
      ? {
    //'ios': '[YOUR iOS AD UNIT ID]',
    'android': 'ca-app-pub-7909363627067674/3092179570',
  }
      : {
    'ios': 'ca-app-pub-3940256099942544/2934735716',
    'android': 'ca-app-pub-3940256099942544/6300978111',
  };

  static final Map<String, String> ADFIT = {
    'ios': '',
    'android': 'DAN-CEYSYT2mDF35sn4t',
  };

  late double _width;
  late BannerAd? _admobBanner;
  late bool _isSecondTry;
  late Widget _ad;

  @override
  void initState() {
    super.initState();
    _isSecondTry = false;
  }

  @override
  void dispose() {
    _admobBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    if (_isSecondTry) {
      _ad = _loadAdFitBanner();
    } else {
      _ad = _loadAdMobBanner();
    }
    return Container(
      alignment: Alignment.center,
      child: _ad,
      width: _width,
      height: 50,
    );
  }

  Widget _loadAdMobBanner() {
    _admobBanner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _isSecondTry = true;
          setState(() {});
        },
        onAdLoaded: (_) {},
      ),
      size: AdSize(width: _width.toInt(), height: 50),
      adUnitId: ADMOB[Platform.isAndroid ? 'android' : 'ios']!,
      request: const AdRequest(),
    )..load();
    return AdWidget(ad: _admobBanner!);
  }

  Widget _loadAdFitBanner() {
    return AdFitBanner(
        adId: ADFIT[Platform.isAndroid ? 'android' : 'ios']!,
        adSize: AdFitBannerSize.SMALL_BANNER,
        listener: (AdFitEvent event, AdFitEventData data) {
        }
    );
  }
}