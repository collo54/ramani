import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramanirides/providers/markers_provider.dart';

import 'page_index.dart';
import 'previous_page_index.dart';

final pageIndexProvider = NotifierProvider<PageIndex, int>(PageIndex.new);
final previousPageIndexProvider =
    NotifierProvider<PreviousPageIndex, List<int>>(PreviousPageIndex.new);
final markerProvider =
    NotifierProvider<MarkersProvider, Set<Marker>>(MarkersProvider.new);
