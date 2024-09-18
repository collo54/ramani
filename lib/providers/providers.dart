import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramaniride/providers/markers_provider.dart';
import 'package:ramaniride/services/location_service.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_storage_service.dart';
import '../services/firestore_service.dart';
import '../services/purchases_service.dart';
import 'current_location_provider.dart';
import 'page_index.dart';
import 'previous_page_index.dart';
import 'user_model_provider.dart';

final pageIndexProvider = NotifierProvider<PageIndex, int>(PageIndex.new);
final previousPageIndexProvider =
    NotifierProvider<PreviousPageIndex, List<int>>(PreviousPageIndex.new);
final markerProvider =
    NotifierProvider<MarkersProvider, Set<Marker>>(MarkersProvider.new);

final currentLocationProvider =
    NotifierProvider<LatLngProviderListener, LatLng>(
        LatLngProviderListener.new);

final locationServiceProvider = Provider((ref) {
  final locationSercive = LocationService();
  return locationSercive;
});

final purchaseServiceProvider = Provider((ref) {
  final purchaseSercive = PurchasesService();
  return purchaseSercive;
});

final scaffoldScrimProvider = Provider((ref) {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  return scaffoldKey;
});

final userModelProvider =
    NotifierProvider<UserModelProviderListener, UserModel>(
        UserModelProviderListener.new);

/// creates a provider for AuthService class
final authenticate = Provider((ref) => AuthService());

/// creates a provider for Firestore service class
final cloudFirestoreServiceProvider = Provider((ref) {
  final usermodel = ref.watch(userModelProvider);
  return FirestoreService(uid: usermodel.uid);
});

/// creates a provider for Firestore service class
final firebaseStorageServiceProvider = Provider((ref) {
  final usermodel = ref.watch(userModelProvider);
  return FirebaseStorageService(uid: usermodel.uid);
});
