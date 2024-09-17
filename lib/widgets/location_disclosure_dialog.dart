import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramaniride/providers/providers.dart';

class LocationDisclosureDialog extends ConsumerWidget {
  const LocationDisclosureDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentLocationProvider);
    final currentScaffold = ref.watch(scaffoldScrimProvider);
    return AlertDialog(
      title: const Text('Background Location Disclosure'),
      content: const Text(
          'The RamaniRide app collects background location data even when the app is closed or not in use to sync with nearby custom user markers. This allows us to provide you with updates on the status of nearby custom markers and prompt you for relevant actions. Such as a fallen tree marker on a hike trail could prompt other users within its proximity to be cautious or prompt to show hike trail is clear.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            currentScaffold.currentState!.showBodyScrim(false, 0.6);
            Navigator.of(context).pop();
          },
          child: const Text('Deny'),
        ),
        TextButton(
          onPressed: () {
            currentScaffold.currentState!.showBodyScrim(false, 0.6);
            Future(() async {
              final locationService = ref.watch(locationServiceProvider);
              var isPermissionGranted = await locationService.checkPermission();
              if (isPermissionGranted) {
                final locationData = await locationService.getLocation();
                if (locationData != null) {
                  var latlngHolder = LatLng(
                    locationData.latitude ?? -37.8136,
                    locationData.longitude ?? 144.9631,
                  );
                  ref
                      .read(currentLocationProvider.notifier)
                      .updateLatLng(latlngHolder);
                }
              }
            });

            Navigator.of(context).pop();
          },
          child: const Text('Accept'),
        ),
      ],
    );
  }
}
