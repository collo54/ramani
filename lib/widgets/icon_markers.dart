import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/colors.dart';
import '../custom/asset_string.dart';
import '../providers/providers.dart';

class IconMarkers extends ConsumerWidget {
  final List<String> iconList;

  IconMarkers({
    super.key,
    required this.iconList,
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
                await currentLocationCustomMarker(
                    ref, context, iconList[index]);
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

  Future<void> currentLocationCustomMarker(
      WidgetRef ref, BuildContext context, pngString) async {
    try {
      final locationService = ref.watch(locationServiceProvider);
      final locationData = await locationService.getLocation();
      if (locationData != null) {
        var latlngHolder =
            LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
        final assetMarkers = MarkersAssets();
        await assetMarkers
            .singleCustomMarkers(
          center: latlngHolder,
          context: context,
          pngString: pngString,
        )
            .then((value) {
          ref.read(markerProvider.notifier).addMarkerSet(value);
        });
      } else {
        Fluttertoast.showToast(
            msg:
                "IconMarker class currentLocationCustomMarker method Exception: Null LocationData ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kred236575710,
            textColor: kwhite25525525510,
            fontSize: 16.0);
      }
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
