import 'package:flutter/material.dart';

class Header2Delegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  Header2Delegate({required this.child});

  static const double smallScreenHeight = 110.0;
  static const double defaultHeight = 60.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Material(
        elevation: overlapsContent ? 4 : 0,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => WidgetsBinding
              .instance.platformDispatcher.views.first.physicalSize.width <
          600
      ? smallScreenHeight
      : defaultHeight;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
