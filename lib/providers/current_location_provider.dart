import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// final latLngProvider = StateNotifierProvider<LatLngProviderListener, LatLng>(
//   (ref) => LatLngProviderListener(),
// );

class LatLngProviderListener extends Notifier<LatLng> {
  @override
  LatLng build() {
    return const LatLng(-37.8136, 144.9631);
  }

  void updateLatLng(LatLng latLng) {
    state = latLng;
    debugPrint('current LatLng :( ${state.latitude} ${state.longitude} )');
  }

  void claerLatLng() {
    state = const LatLng(-37.8136, 144.9631);
    debugPrint('clear LatLng :( ${state.latitude} ${state.longitude} )');
  }
}
