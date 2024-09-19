import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:location/location.dart';
import 'package:ramaniride/constants/colors.dart';
import 'package:ramaniride/custom/asset_string.dart';
import 'package:ramaniride/widgets/create_marker_bottomsheet.dart';

import '../painters/notebook_painter.dart';
import '../providers/providers.dart';
import '../widgets/create_mylocation_marker.dart';
import '../widgets/icon_markers.dart';
import '../widgets/single_icon_marker.dart';

class MapsPage extends ConsumerStatefulWidget {
  MapsPage({super.key});

  @override
  ConsumerState<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends ConsumerState<MapsPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-37.8136, 144.9631);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(
    GoogleMapController controller,
  ) async {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final currentTab = ref.watch(pageIndexProvider);
    final purchaseService = ref.watch(purchaseServiceProvider);
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
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final auth = ref.read(authenticate);
              await auth.signOut();
            },
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedLogout01,
              color: kblack00008,
              size: 24.0,
            ),
          ),
        ],
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
                  onLongPress: (latlang) async {
                    try {
                      showBottomSheet(
                        context: context,
                        builder: (context) => CreateMarkerBottomsheet(
                          iconList: MarkersAssets().customPngString,
                          latlng: latlang,
                          mapController: mapController,
                        ),
                      );
                    } on Exception catch (e) {
                      Fluttertoast.showToast(
                          msg: "Error creating marker: $e",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => SingleIconMarkers(
                    //     iconList: MarkersAssets().customPngString,
                    //     latlng: latlang,
                    //     mapController: mapController,
                    //   ),
                    // );
                  },
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
            // Positioned(
            //   left: 10,
            //   bottom: 10,
            //   child: FloatingActionButton(
            //     foregroundColor: kblack15161810,
            //     backgroundColor: kwhite25525525510,
            //     onPressed: () async {
            //       await purchaseService.presentPaywallUI();
            //       final assetMarkers = MarkersAssets();
            //       const latlngHolder = LatLng(
            //           -37.8136 - 0.5, 144.9631 - 0.5); //TODO dynamic latlng
            //       await assetMarkers
            //           .customMarkersTest(context, latlngHolder)
            //           .then((value) {
            //         ref.read(markerProvider.notifier).replaceSet(value);
            //       });
            //     },
            //     child: const HugeIcon(
            //         color: kpurple1215720310,
            //         icon: HugeIcons.strokeRoundedLocation09),
            //   ),
            // ),
            Positioned(
              left: 10,
              bottom: 30,
              child: FloatingActionButton(
                foregroundColor: kblack15161810,
                backgroundColor: kwhite25525525510,
                onPressed: () async {
                  try {
                    showBottomSheet(
                      context: context,
                      builder: (context) => CreateMyLocationMarkerBottomsheet(
                        iconList: MarkersAssets().customPngString,
                        mapController: mapController,
                      ),
                    );
                  } on Exception catch (e) {
                    Fluttertoast.showToast(
                        msg: "Error creating marker: $e",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => IconMarkers(
                  //     iconList: MarkersAssets().customPngString,
                  //     mapController: mapController,
                  //   ),
                  // );
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
