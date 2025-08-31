import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'custom/auth_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    debugPrint("Starting Firebase initialization...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase initialized successfully.");

    debugPrint("Configuring SDKs...");
    await _configureSDK();
    debugPrint("SDKs configured successfully.");

    // This will only run if the above lines succeed
    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    // CATCH THE ERROR HERE
    debugPrint("!!!!!!!!!! CAUGHT ERROR IN main() !!!!!!!!!!");
    debugPrint("Error: $e");
    debugPrint("Stack Trace: $stackTrace");
    // Fluttertoast.showToast(
    //   msg: "Error initializing app: $e : Stack Trace: $stackTrace",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.red,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
    // You could potentially show an error screen here instead of a blank one
  }
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // runApp(
  //   const ProviderScope(
  //     child: MyApp(),
  //   ),
  // );

  // await _configureSDK();
}

// String get androidConfigurationKey =>
//     const String.fromEnvironment('REVCAT_ANDROID_API_KEY');
String get androidConfigurationKey {
  const key = String.fromEnvironment('REVCAT_ANDROID_API_KEY');
  // debugPrint("REVCAT_ANDROID_API_KEY from environment: '$key'"); // Add this line
  // Fluttertoast.showToast(
  //   msg: "REVCAT_ANDROID_API_KEY from environment: '$key'",
  //   toastLength: Toast.LENGTH_LONG,
  //   gravity: ToastGravity.BOTTOM,
  //   timeInSecForIosWeb: 1,
  //   backgroundColor: Colors.black,
  //   textColor: Colors.white,
  //   fontSize: 16.0,
  // );
  // if (key.isEmpty) {
  //   debugPrint("WARNING: REVCAT_ANDROID_API_KEY is empty!");
  // }
  return key;
}

String get iosConfigurationKey =>
    const String.fromEnvironment('REVCAT_IOS_API_KEY');

String get webConfigurationKey =>
    const String.fromEnvironment('REVCAT_WEB_API_KEY');

Future<void> _configureSDK() async {
  // Enable debug logs before calling `configure`.
  try {
    await Purchases.setLogLevel(LogLevel.debug);

    if (kIsWeb) {
      var webPurchaseConfig = PurchasesConfiguration(webConfigurationKey);
      return await Purchases.configure(webPurchaseConfig);
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        var androidPurchaseConfig = PurchasesConfiguration(
          androidConfigurationKey,
        );
        return await Purchases.configure(androidPurchaseConfig);
      case TargetPlatform.iOS:
        var iosPurchaseConfig = PurchasesConfiguration(iosConfigurationKey);
        return await Purchases.configure(iosPurchaseConfig);

      default:
        var androidPurchaseConfig = PurchasesConfiguration(
          androidConfigurationKey,
        );
        return await Purchases.configure(androidPurchaseConfig);
    }
  } on Exception catch (e) {
    // Fluttertoast.showToast(
    //   msg: "Error initializing revenuecat: $e",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.redAccent,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RamaniRide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const AuthState(), // const HomeScaffold(),
    );
  }
}
