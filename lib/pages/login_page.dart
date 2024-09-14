import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramanirides/providers/providers.dart';

import '../layouts/login_layout.dart';
import '../painters/notebook_painter.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final currentScaffold = ref.watch(scaffoldScrimProvider);
    return Scaffold(
      key: currentScaffold,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: NotebookPagePainter(),
            child: Center(
              child: LoginMobileLayout(
                currentScaffold: currentScaffold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
