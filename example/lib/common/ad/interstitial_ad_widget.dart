import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:screen_capture_event_example/ui/pages/layout.dart';

class InterstitialAdWidget {
  static final Map<String, String> UNIT_ID = kReleaseMode
      ? {
    //'ios': '[YOUR iOS AD UNIT ID]',
    'android': 'ca-app-pub-9201118486372073/4083964131',
  }
      : {
    'ios': 'ca-app-pub-3940256099942544/2934735716',
    'android': 'ca-app-pub-3940256099942544/1033173712',
  };
  static const int maxFailedLoadAttempts = 3;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;


  Future<void> init(BuildContext context) {
    return _createInterstitialAd(context);
  }

  bool isLoaded() {
    return _interstitialAd != null;
  }

  Future<void> _createInterstitialAd(BuildContext context) {
    return InterstitialAd.load(
        adUnitId: UNIT_ID[Platform.isAndroid ? 'android' : 'ios']!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);

            _showInterstitialAd(context);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd(context);
            }
          },
        ));
  }

  void _showInterstitialAd(BuildContext context) {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();

        //MoveToBackground.moveTaskToBack();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();

        //MoveToBackground.moveTaskToBack();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}