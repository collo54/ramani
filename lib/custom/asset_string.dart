import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersAssets {
  List<String> customPngString = [
    'assets/icons/accident.png',
    'assets/icons/building.png',
    'assets/icons/crisis.png',
    'assets/icons/fallen-tree.png',
    'assets/icons/food.png',
    'assets/icons/handcuffs.png',
    'assets/icons/home(3).png',
    'assets/icons/roadblock.png',
    'assets/icons/traffic-jam.png',
    'assets/icons/tripod.png',
  ];

  final List<LatLng> _centerList = [
    const LatLng(-37.8136 + 0.1, 144.9631 + 0.1),
    const LatLng(-37.8136 - 0.1, 144.9631 - 0.1),
    const LatLng(-37.8136 + 0.2, 144.9631 + 0.2),
    const LatLng(-37.8136 - 0.2, 144.9631 - 0.2),
    const LatLng(-37.8136 + 0.3, 144.9631 + 0.3),
    const LatLng(-37.8136 - 0.3, 144.9631 - 0.3),
    const LatLng(-37.8136 + 0.4, 144.9631 + 0.4),
    const LatLng(-37.8136 - 0.4, 144.9631 - 0.4),
    const LatLng(-37.8136 + 0.5, 144.9631 + 0.5),
    const LatLng(-37.8136 - 0.5, 144.9631 - 0.5),
  ];

  Future<Set<Marker>> customMarkersTest(
    BuildContext context,
    LatLng center,
  ) async {
    var listMarker = <Marker>{};
    for (String pngString in customPngString) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context); // ImageConfiguration();
      BitmapDescriptor bitmapDescriptor =
          await BitmapDescriptor.asset(imageConfiguration, pngString);
      Marker marker = Marker(
        markerId: MarkerId(pngString),
        position: _centerList.elementAt(customPngString.indexOf(pngString)),
        icon: bitmapDescriptor,
      );
      listMarker.add(marker);
    }
    return listMarker;
  }

  Future<Set<Marker>> singleCustomMarkers({
    required BuildContext context,
    required LatLng center,
    required String pngString,
  }) async {
    var listMarker = <Marker>{};

    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context); // ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.asset(imageConfiguration, pngString);
    Marker marker = Marker(
      markerId: MarkerId(pngString),
      position: center,
      icon: bitmapDescriptor,
    );
    listMarker.add(marker);

    return listMarker;
  }

  Future<Set<Marker>> newsingleCustomMarkers({
    required BuildContext context,
    required LatLng center,
    required String pngString,
    required String markerId,
    required String title,
  }) async {
    var listMarker = <Marker>{};

    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context); // ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.asset(imageConfiguration, pngString);
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      infoWindow: InfoWindow(
        title: title,
      ),
      position: center,
      icon: bitmapDescriptor,
    );
    listMarker.add(marker);

    return listMarker;
  }

  //   final Map<String, Marker> _markers = {};
  // Future<void> _onMapCreatedTest(GoogleMapController controller) async {
  //   final googleOffices = await locations.getGoogleOffices();
  //   setState(() {
  //     _markers.clear();
  //     for (final office in googleOffices.offices) {
  //       final marker = Marker(
  //         markerId: MarkerId(office.name),
  //         position: LatLng(office.lat, office.lng),
  //         infoWindow: InfoWindow(
  //           title: office.name,
  //           snippet: office.address,
  //         ),
  //       );
  //       _markers[office.name] = marker;
  //     }
  //   });
  // }
}
