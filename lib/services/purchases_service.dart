import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:ramaniride/constants/colors.dart';

class PurchasesService {
  static const entitlementId = "premium";

  Future<void> presentPaywallUI() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(
          entitlementId,
          displayCloseButton: true);
      debugPrint("paywall result: $paywallResult");
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Error presentwallUI method PurchasesService class: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kred236575710,
          textColor: kwhite25525525510,
          fontSize: 16.0);
      if (kDebugMode) {
        print('Error presentwallUI method PurchasesService class: $e');
      }
      rethrow;
    }
  }

  Future<CustomerInfo> getCustomerInfoListener() async {
    late CustomerInfo customerInfo;
    Purchases.addCustomerInfoUpdateListener((info) async {
      customerInfo = info;
    });

    return customerInfo;
  }
}
