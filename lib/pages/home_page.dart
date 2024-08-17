import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../painters/notebook_painter.dart';
import '../providers/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final currentTab = ref.watch(pageIndexProvider);
    ref.watch(previousPageIndexProvider);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: NotebookPagePainter(),
        ),
      ),
    );
  }
}
