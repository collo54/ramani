import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramanirides/custom/home_scaffold.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'custom/auth_state.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

  await _configureSDK();
}

String get androidConfigurationKey =>
    const String.fromEnvironment('REVCAT_ANDROID_API_KEY');

String get iosConfigurationKey =>
    const String.fromEnvironment('REVCAT_IOS_API_KEY');

String get webConfigurationKey =>
    const String.fromEnvironment('REVCAT_WEB_API_KEY');

Future<void> _configureSDK() async {
  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  var webPurchaseConfig = PurchasesConfiguration(webConfigurationKey);
  var androidPurchaseConfig = PurchasesConfiguration(androidConfigurationKey);
  var iosPurchaseConfig = PurchasesConfiguration(iosConfigurationKey);

  if (kIsWeb) {
    return await Purchases.configure(webPurchaseConfig);
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return await Purchases.configure(androidPurchaseConfig);
    case TargetPlatform.iOS:
      return await Purchases.configure(iosPurchaseConfig);

    default:
      return await Purchases.configure(androidPurchaseConfig);
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
