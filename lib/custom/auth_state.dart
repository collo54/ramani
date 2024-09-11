import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../pages/login_page.dart';
import '../providers/providers.dart';
import '../providers/user_login_stream_provider.dart';
import 'home_scaffold.dart';

class AuthState extends ConsumerWidget {
  const AuthState({super.key, this.page});
  final int? page;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('authstate called ****');
    ref.watch(userModelProvider);
    ref.watch(currentLocationProvider);
    final value = ref.watch(userProvider);
    return value.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      data: (user) {
        Future(() async {
          final locationService = ref.watch(locationServiceProvider);
          var isPermissionGranted = await locationService.checkPermission();
          if (isPermissionGranted) {
            final locationData = await locationService.getLocation();
            if (locationData == null) {
              var latlngHolder = LatLng(
                locationData?.latitude ?? -37.8136,
                locationData?.longitude ?? 144.9631,
              );
               ref.read(currentLocationProvider.notifier).updateLatLng(latlngHolder);
            }
          }
        });
        if (user != null) {
          Future(() {
            ref.read(userModelProvider.notifier).updateUserModel(user);
          });

          return const HomeScaffold();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
