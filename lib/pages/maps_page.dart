import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ramanirides/constants/colors.dart';
import 'package:ramanirides/custom/asset_string.dart';

import '../painters/notebook_painter.dart';
import '../providers/providers.dart';

class MapsPage extends ConsumerWidget {
  MapsPage({super.key});

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-37.8136, 144.9631);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final currentTab = ref.watch(pageIndexProvider);
    var markers = ref.watch(markerProvider);
    ref.watch(previousPageIndexProvider);
    return SizedBox(
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
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: _center, //TODO  initial location
                  zoom: 4.0,
                  tilt : 0.7,
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
                const latlngHolder = LatLng(-37.8136 - 0.5, 144.9631 - 0.5); //TODO dynamic latlng
                await assetMarkers
                    .customMarkers(context, latlngHolder)
                    .then((value) {
                  ref.read(markerProvider.notifier).replaceSet(value);
                });
              },
              child: const HugeIcon(
                  color: kpurple1215720310,
                  icon: HugeIcons.strokeRoundedLocation09),
            ),
          ),
        ],
      ),
    );
  }
}
