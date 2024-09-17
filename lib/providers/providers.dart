import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramaniride/providers/markers_provider.dart';
import 'package:ramaniride/services/location_service.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
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

final scaffoldScrimProvider = Provider((ref) {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  return scaffoldKey;
});

final userModelProvider =
    NotifierProvider<UserModelProviderListener, UserModel>(
        UserModelProviderListener.new);

/// creates a provider for AuthService class
final authenticate = Provider((ref) => AuthService());
