import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:location/location.dart';
import 'package:ramanirides/constants/colors.dart';
import 'package:ramanirides/custom/asset_string.dart';

import '../painters/notebook_painter.dart';
import '../providers/providers.dart';
import '../widgets/icon_markers.dart';

class MapsPage extends ConsumerWidget {
  MapsPage({super.key});

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-37.8136, 144.9631);

  void _onMapCreated(
    GoogleMapController controller,
  ) async {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final currentTab = ref.watch(pageIndexProvider);
    var markers = ref.watch(markerProvider);
    var currentLoc = ref.watch(currentLocationProvider);
    ref.watch(locationServiceProvider);
    ref.watch(previousPageIndexProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Navigate Maps',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: kblack00008,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: NotebookPagePainter(),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: currentLoc, //TODO  initial location
                    zoom: 15.0,
                    tilt: 20.0,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: FloatingActionButton(
                foregroundColor: kblack15161810,
                backgroundColor: kwhite25525525510,
                onPressed: () async {
                  final assetMarkers = MarkersAssets();
                  const latlngHolder = LatLng(
                      -37.8136 - 0.5, 144.9631 - 0.5); //TODO dynamic latlng
                  await assetMarkers
                      .customMarkersTest(context, latlngHolder)
                      .then((value) {
                    ref.read(markerProvider.notifier).replaceSet(value);
                  });
                },
                child: const HugeIcon(
                    color: kpurple1215720310,
                    icon: HugeIcons.strokeRoundedLocation09),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 100,
              child: FloatingActionButton(
                foregroundColor: kblack15161810,
                backgroundColor: kwhite25525525510,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => IconMarkers(
                      iconList: MarkersAssets().customPngString,
                    ),
                  );
                },
                child: const HugeIcon(
                  color: kpurple1215720310,
                  icon: HugeIcons.strokeRoundedMapPinpoint01,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> currentLocationCustomMarker(
      WidgetRef ref, BuildContext context) async {
    final locationService = ref.watch(locationServiceProvider);
    final locationData = await locationService.getLocation();
    if (locationData == null) {
      var latlngHolder =
          LatLng(locationData?.latitude ?? 0, locationData?.longitude ?? 0);
      final assetMarkers = MarkersAssets();
      await assetMarkers
          .singleCustomMarkers(
        center: latlngHolder,
        context: context,
        pngString: 'assets/icons/accident.png',
      )
          .then((value) {
        ref.read(markerProvider.notifier).addMarkerSet(value);
      });
    } else {}
  }
}
