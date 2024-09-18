import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';

import '../constants/colors.dart';
import '../custom/asset_string.dart';
import '../providers/providers.dart';

class SingleIconMarkers extends ConsumerWidget {
  final List<String> iconList;
  final LatLng latlng;
  GoogleMapController mapController;

  SingleIconMarkers({
    super.key,
    required this.iconList,
    required this.latlng,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(markerProvider);
    return AlertDialog(
      icon: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const HugeIcon(
          color: kblack000010,
          icon: HugeIcons.strokeRoundedCancel01,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: iconList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await currentLocationCustomMarker(ref, context, iconList[index],
                    getIconName(iconList[index]));
              },
              child: ListTile(
                leading: Image.asset(
                  iconList[index],
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  getIconName(iconList[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String getIconName(String path) {
    final regex = RegExp(r'/([^/]+)\.(png|jpg)');
    final match = regex.firstMatch(path);
    if (match != null) {
      return match.group(1) ?? 'null group';
    } else {
      return 'null match';
    }
  }

  Future<void> currentLocationCustomMarker(WidgetRef ref, BuildContext context,
      pngString, String infoWindowString) async {
    try {
      var uuid = const Uuid();
      final assetMarkers = MarkersAssets();
      await assetMarkers
          .newsingleCustomMarkers(
        title: infoWindowString,
        markerId: uuid.v1(),
        center: latlng,
        context: context,
        pngString: pngString,
      )
          .then((value) {
        ref.read(markerProvider.notifier).addMarkerSet(value);
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latlng,
            zoom: 15.0,
            tilt: 20.0,
          ),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg:
              "IconMarker class currentLocationCustomMarker method Exception: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kred236575710,
          textColor: kwhite25525525510,
          fontSize: 16.0);
    }
  }
}
