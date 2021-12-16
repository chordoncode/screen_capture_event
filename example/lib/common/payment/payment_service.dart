import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:screen_capture_event_example/common/storage/shared_storage.dart';
import 'package:screen_capture_event_example/common/storage/shared_storage_key.dart';

class PaymentService {
  static const List<String> _kProductIds = <String>['subscription_gold'];

  PaymentService._internal();

  static final PaymentService instance = PaymentService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  dynamic _callback;

  init() async {
    await _init();
  }

  Future<void> _init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {});
    await _initStoreInfo();
    await _inAppPurchase.restorePurchases();
  }

  void dispose() {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    if (purchaseDetailsList.isEmpty) {
      _purchases.clear();
      _purchasePending = false;
      _callback??_callback();
      return;
    }
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
        _callback??_callback();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
        _callback??_callback();
      }
    }
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await  _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = isAvailable;
      _products = [];
      _purchases = [];
      _purchasePending = false;

      return;
    }

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;

      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;

      return;
    }

    _isAvailable = isAvailable;
    _products = productDetailResponse.productDetails;
    _purchasePending = false;
  }

  void _showPendingUI() {
    _purchasePending = true;
  }

  void _handleError(IAPError error) {
    _purchasePending = false;
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) async {
    _purchases.add(purchaseDetails);
    _purchasePending = false;
    SharedStorage.write(SharedStorageKey.pro, true);
  }

  _verifyPurchase(PurchaseDetails purchaseDetails) {
    return true;
  }

  List<PurchaseDetails> getPurchases() {
    return _purchases;
  }

  List<ProductDetails> getProducts() {
    return _products;
  }

  bool isPro() {
    return _isAvailable ? _purchases.isNotEmpty : SharedStorage.read(SharedStorageKey.pro);
  }

  bool isAvailable() {
    return _isAvailable;
  }

  bool isPurchasePending() {
    return _purchasePending;
  }

  Future<void> restorePurchases() async {
    _inAppPurchase.restorePurchases();
  }

  void setCallBack(callback) {
    _callback = callback;
  }

  Future<void> buyProduct(final ProductDetails productDetails) async {
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}