import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersProvider extends Notifier<Set<Marker>> {
  @override
  Set<Marker> build() {
    return {};
  }

  void replaceSet(Set<Marker> markerSet) {
    clearSet();
    state = {...state, ...markerSet};
    debugPrint('current Marker Set:$state');
  }

  void currentMarker(Marker index) {
    state = {...state, index};
    debugPrint('current Marker Set Indexes:$state');
  }

  void clearSet() {
    state = {};
    debugPrint('clear Marker Set Indexes:$state');
  }
}
