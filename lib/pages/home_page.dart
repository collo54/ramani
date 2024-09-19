import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ramaniride/constants/colors.dart';
//import 'package:ramaniride/widgets/thumbnail_widget.dart';

import '../layouts/home_layout.dart';
import '../painters/notebook_painter.dart';
import '../providers/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

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
          '#Private channel',
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
        //       icon: HugeIcons.strokeRoundedAdd01,
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
            child: const HomeLayout(),
          ),
        ),
      ),
    );
  }
}
