import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/colors.dart';
import '../pages/checkout_page.dart';
import '../pages/home_page.dart';
import '../pages/maps_page.dart';
import '../providers/providers.dart';

class HomeScaffold extends ConsumerWidget {
  const HomeScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final currentTab = ref.watch(pageIndexProvider);
    ref.watch(previousPageIndexProvider);
    return DefaultTabController(
      length: 3,
      initialIndex: currentTab,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MapsPage(),
            HomePage(),
            CheckoutPage(),
          ],
        ),
        bottomNavigationBar: Card(
          elevation: 4,
          color: kwhite25525525510,
          child: TabBar(
            onTap: (value) {
              ref.read(pageIndexProvider.notifier).currentIndex(value);
              ref.read(previousPageIndexProvider.notifier).currentIndex(value);
            },
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: kblue12915824210,
            tabs: [
              Tab(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedMapsLocation02,
                  color: currentTab == 0 ? kblue12915824210 : kblack00005,
                  size: 24.0,
                ),
              ),
              Tab(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedSearchArea,
                  color: currentTab == 1 ? kblue12915824210 : kblack00005,
                  size: 24.0,
                ),
              ),
              Tab(
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedPayment02,
                  color: currentTab == 2 ? kblue12915824210 : kblack00005,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
