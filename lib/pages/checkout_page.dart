import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/colors.dart';
import '../painters/notebook_painter.dart';
import '../providers/providers.dart';
import '../widgets/instructions_widget.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final currentTab = ref.watch(pageIndexProvider);
    ref.watch(previousPageIndexProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kwhite25525525510,
        surfaceTintColor: kwhite25525525510,
        title: Text(
          'Subscriptions info',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: kblack00008,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () async {},
        //     icon: const HugeIcon(
        //       icon: HugeIcons.strokeRoundedSettings01,
        //       color: kblack00008,
        //       size: 24.0,
        //     ),
        //   ),
        // ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: NotebookPagePainter(),
            child: const Column(
              children: [
                InstructionsWidget(
                  title: 'Instructions',
                  description:
                      'This tab shows subscriptions info for easy access.\nNavigate to the first tab to create custom map markers.\nSaved Markers from different channels will appear on the second tab.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
