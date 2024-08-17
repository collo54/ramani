import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'page_index.dart';
import 'previous_page_index.dart';

final pageIndexProvider = NotifierProvider<PageIndex, int>(PageIndex.new);
final previousPageIndexProvider =
    NotifierProvider<PreviousPageIndex, List<int>>(PreviousPageIndex.new);
