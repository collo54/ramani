import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_map_data_model.dart';
import 'providers.dart';

final readPrivateMarkersProvider =
    StreamProvider<List<UserMapDataModel>>((ref) {
  debugPrint('streamProvider called   ***** ');
  final userDataStream = ref.watch(cloudFirestoreServiceProvider);

  return userDataStream.userMapDataModelStream();
});